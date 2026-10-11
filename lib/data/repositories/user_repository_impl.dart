import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/database/database_helper.dart';
import '../models/user_model.dart';
import '../models/card_model.dart';

class UserRepositoryImpl implements UserRepository {
  final DatabaseHelper _dbHelper;

  UserRepositoryImpl(this._dbHelper);

  @override
  Future<User> createUser(User user) async {
    final db = await _dbHelper.database;
    final userModel = UserModel.fromEntity(user);
    await db.insert('users', userModel.toMap());
    return user;
  }

  @override
  Future<User?> getUserById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final userModel = UserModel.fromMap(maps.first);

    // Get associated card IDs
    final cardMaps = await db.query(
      'metro_cards',
      columns: ['id'],
      where: 'user_id = ?',
      whereArgs: [id],
    );

    final cardIds = cardMaps.map((map) => map['id'] as String).toList();

    return userModel.copyWith(cardIds: cardIds).toEntity();
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;

    final userModel = UserModel.fromMap(maps.first);

    // Get associated card IDs
    final cardMaps = await db.query(
      'metro_cards',
      columns: ['id'],
      where: 'user_id = ?',
      whereArgs: [userModel.id],
    );

    final cardIds = cardMaps.map((map) => map['id'] as String).toList();

    return userModel.copyWith(cardIds: cardIds).toEntity();
  }

  @override
  Future<User> updateUser(User user) async {
    final db = await _dbHelper.database;
    final userModel = UserModel.fromEntity(user);
    await db.update(
      'users',
      userModel.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return user;
  }

  @override
  Future<void> deleteUser(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<User>> getAllUsers() async {
    final db = await _dbHelper.database;
    final maps = await db.query('users');

    List<User> users = [];
    for (var map in maps) {
      final userModel = UserModel.fromMap(map);

      // Get associated card IDs
      final cardMaps = await db.query(
        'metro_cards',
        columns: ['id'],
        where: 'user_id = ?',
        whereArgs: [userModel.id],
      );

      final cardIds = cardMaps.map((map) => map['id'] as String).toList();
      users.add(userModel.copyWith(cardIds: cardIds).toEntity());
    }

    return users;
  }

  @override
  Future<bool> userExists(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      columns: ['COUNT(*) as count'],
      where: 'id = ?',
      whereArgs: [id],
    );

    final count = result.first['count'] as int;
    return count > 0;
  }
}
