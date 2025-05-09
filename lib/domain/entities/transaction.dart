// lib/domain/entities/transaction.dart
enum TransactionType {
  recharge,
  fare,
  refund,
}

class Transaction {
  final String id;
  final String cardId;
  final String userId;
  final double amount;
  final TransactionType type;
  final DateTime timestamp;
  final String? description;
  final String? journeyId; // Reference to a Journey entity if transaction is a fare

  const Transaction({
    required this.id,
    required this.cardId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.timestamp,
    this.description,
    this.journeyId,
  });

  @override
  String toString() {
    return 'Transaction(id: $id, cardId: $cardId, userId: $userId, amount: $amount, type: $type, timestamp: $timestamp, description: $description, journeyId: $journeyId)';
  }
}