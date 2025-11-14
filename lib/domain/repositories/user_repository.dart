import '../entities/user.dart';

abstract class UserRepository {
  /// Create a new user
  Future<User> createUser(User user);

  /// Get user by ID
  Future<User?> getUserById(String id);

  /// Get user by email
  Future<User?> getUserByEmail(String email);

  /// Update user
  Future<User> updateUser(User user);

  /// Delete user
  Future<void> deleteUser(String id);

  /// Get all users
  Future<List<User>> getAllUsers();

  /// Check if user exists
  Future<bool> userExists(String id);
}
