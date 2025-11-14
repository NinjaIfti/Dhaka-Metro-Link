import '../entities/transaction.dart';

abstract class TransactionRepository {
  /// Create a new transaction
  Future<Transaction> createTransaction(Transaction transaction);

  /// Get transaction by ID
  Future<Transaction?> getTransactionById(String id);

  /// Get all transactions for a card
  Future<List<Transaction>> getTransactionsByCardId(String cardId);

  /// Get all transactions for a user
  Future<List<Transaction>> getTransactionsByUserId(String userId);

  /// Get recent transactions for a user (limited)
  Future<List<Transaction>> getRecentTransactionsByUserId(
    String userId, {
    int limit = 10,
  });

  /// Get transactions by type
  Future<List<Transaction>> getTransactionsByType(
    String userId,
    TransactionType type,
  );

  /// Get transactions by date range
  Future<List<Transaction>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Update transaction
  Future<Transaction> updateTransaction(Transaction transaction);

  /// Delete transaction
  Future<void> deleteTransaction(String id);

  /// Get all transactions
  Future<List<Transaction>> getAllTransactions();

  /// Get total recharge amount for user
  Future<double> getTotalRechargeAmount(String userId);

  /// Get total fare amount for user
  Future<double> getTotalFareAmount(String userId);
}
