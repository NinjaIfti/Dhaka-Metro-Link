import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final UserRepository _userRepository;
  final SharedPreferences _prefs;

  User? _currentUser;
  bool _isAuthenticated = false;

  AuthService(this._userRepository, this._prefs) {
    _loadSession();
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUser?.id;

  // Load session from SharedPreferences
  Future<void> _loadSession() async {
    final userId = _prefs.getString('current_user_id');
    if (userId != null) {
      final user = await _userRepository.getUserById(userId);
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();
      } else {
        // User not found, clear session
        await logout();
      }
    }
  }

  // Register new user
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      // Check if email already exists
      final existingUser = await _userRepository.getUserByEmail(email);
      if (existingUser != null) {
        return RegisterResult(
          success: false,
          message: 'Email already registered',
        );
      }

      // Create new user
      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        createdAt: DateTime.now(),
        cardIds: [],
      );

      final createdUser = await _userRepository.createUser(newUser);

      // Auto-login after registration
      await _setCurrentUser(createdUser);

      return RegisterResult(
        success: true,
        message: 'Registration successful',
        user: createdUser,
      );
    } catch (e) {
      debugPrint('Registration error: $e');
      return RegisterResult(
        success: false,
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  // Login user
  Future<LoginResult> login({
    required String email,
  }) async {
    try {
      // Find user by email
      final user = await _userRepository.getUserByEmail(email);

      if (user == null) {
        return LoginResult(
          success: false,
          message: 'User not found. Please register first.',
        );
      }

      // Set as current user
      await _setCurrentUser(user);

      return LoginResult(
        success: true,
        message: 'Login successful',
        user: user,
      );
    } catch (e) {
      debugPrint('Login error: $e');
      return LoginResult(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  // Set current user and save session
  Future<void> _setCurrentUser(User user) async {
    _currentUser = user;
    _isAuthenticated = true;
    await _prefs.setString('current_user_id', user.id);
    notifyListeners();
  }

  // Update user profile
  Future<UpdateResult> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) {
      return UpdateResult(
        success: false,
        message: 'No user logged in',
      );
    }

    try {
      final updatedUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
      );

      await _userRepository.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();

      return UpdateResult(
        success: true,
        message: 'Profile updated successfully',
        user: updatedUser,
      );
    } catch (e) {
      debugPrint('Update profile error: $e');
      return UpdateResult(
        success: false,
        message: 'Update failed: ${e.toString()}',
      );
    }
  }

  // Logout user
  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    await _prefs.remove('current_user_id');
    notifyListeners();
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (_currentUser != null) {
      final user = await _userRepository.getUserById(_currentUser!.id);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    }
  }
}

// Result classes
class RegisterResult {
  final bool success;
  final String message;
  final User? user;

  RegisterResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class LoginResult {
  final bool success;
  final String message;
  final User? user;

  LoginResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class UpdateResult {
  final bool success;
  final String message;
  final User? user;

  UpdateResult({
    required this.success,
    required this.message,
    this.user,
  });
}
