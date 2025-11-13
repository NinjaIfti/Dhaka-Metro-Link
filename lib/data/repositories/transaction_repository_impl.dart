import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../core/database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final DatabaseHelper _dbHelper;

  TransactionRepositoryImpl(this._dbHelper);

  @override
  Future<Transaction> createTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    final transactionModel = TransactionModel.fromEntity(transaction);
    await db.insert('transactions', transactionModel.toMap());
    return transaction;
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return TransactionModel.fromMap(maps.first).toEntity();
  }

  @override
  Future<List<Transaction>> getTransactionsByCardId(String cardId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'transactions',
      where: 'card_id = ?',
      whereArgs: [cardId],
      orderBy: 'timestamp DESC',
    );

    return maps
        .map((map) => TransactionModel.fromMap(map).toEntity())
        .toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return maps
        .map((map) => TransactionModel.fromMap(map).toEntity())
        .toList();
  }

  @override
  Future<List<Transaction>> getRecentTransactionsByUserId(
    String userId, {
    int limit = 10,
  }) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return maps
        .map((map) => TransactionModel.fromMap(map).toEntity())
        .toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByType(
    String userId,
    TransactionType type,
  ) async {
    final db = await _dbHelper.database;

    String typeStr;
    switch (type) {
      case TransactionType.recharge:
        typeStr = 'recharge';
        break;
      case TransactionType.fare:
        typeStr = 'fare';
        break;
      case TransactionType.refund:
        typeStr = 'refund';
        break;
    }

    final maps = await db.query(
      'transactions',
      where: 'user_id = ? AND type = ?',
      whereArgs: [userId, typeStr],
      orderBy: 'timestamp DESC',
    );

    return maps
        .map((map) => TransactionModel.fromMap(map).toEntity())
        .toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'transactions',
      where: 'user_id = ? AND timestamp >= ? AND timestamp <= ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'timestamp DESC',
    );

    return maps
        .map((map) => TransactionModel.fromMap(map).toEntity())
        .toList();
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    final transactionModel = TransactionModel.fromEntity(transaction);
    await db.update(
      'transactions',
      transactionModel.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    return transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final db = await _dbHelper.database;
    final maps = await db.query('transactions', orderBy: 'timestamp DESC');
    return maps
        .map((map) => TransactionModel.fromMap(map).toEntity())
        .toList();
  }

  @override
  Future<double> getTotalRechargeAmount(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE user_id = ? AND type = 'recharge'
    ''', [userId]);

    if (result.isEmpty || result.first['total'] == null) {
      return 0.0;
    }

    return (result.first['total'] as num).toDouble();
  }

  @override
  Future<double> getTotalFareAmount(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE user_id = ? AND type = 'fare'
    ''', [userId]);

    if (result.isEmpty || result.first['total'] == null) {
      return 0.0;
    }

    return (result.first['total'] as num).toDouble();
  }
}
