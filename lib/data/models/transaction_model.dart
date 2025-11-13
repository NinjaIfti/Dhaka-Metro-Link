import '../../domain/entities/transaction.dart';

class TransactionModel {
  final String id;
  final String cardId;
  final String userId;
  final double amount;
  final TransactionType type;
  final DateTime timestamp;
  final String? description;
  final String? journeyId;

  const TransactionModel({
    required this.id,
    required this.cardId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.timestamp,
    this.description,
    this.journeyId,
  });

  // Convert from domain entity
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      cardId: transaction.cardId,
      userId: transaction.userId,
      amount: transaction.amount,
      type: transaction.type,
      timestamp: transaction.timestamp,
      description: transaction.description,
      journeyId: transaction.journeyId,
    );
  }

  // Convert to domain entity
  Transaction toEntity() {
    return Transaction(
      id: id,
      cardId: cardId,
      userId: userId,
      amount: amount,
      type: type,
      timestamp: timestamp,
      description: description,
      journeyId: journeyId,
    );
  }

  // Convert from database map
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      cardId: map['card_id'] as String,
      userId: map['user_id'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: _parseType(map['type'] as String),
      timestamp: DateTime.parse(map['timestamp'] as String),
      description: map['description'] as String?,
      journeyId: map['journey_id'] as String?,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'card_id': cardId,
      'user_id': userId,
      'amount': amount,
      'type': _typeToString(type),
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'journey_id': journeyId,
    };
  }

  // Convert from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      cardId: json['cardId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: _parseType(json['type'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      description: json['description'] as String?,
      journeyId: json['journeyId'] as String?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardId': cardId,
      'userId': userId,
      'amount': amount,
      'type': _typeToString(type),
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'journeyId': journeyId,
    };
  }

  static TransactionType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'recharge':
        return TransactionType.recharge;
      case 'fare':
        return TransactionType.fare;
      case 'refund':
        return TransactionType.refund;
      default:
        return TransactionType.recharge;
    }
  }

  static String _typeToString(TransactionType type) {
    switch (type) {
      case TransactionType.recharge:
        return 'recharge';
      case TransactionType.fare:
        return 'fare';
      case TransactionType.refund:
        return 'refund';
    }
  }

  TransactionModel copyWith({
    String? id,
    String? cardId,
    String? userId,
    double? amount,
    TransactionType? type,
    DateTime? timestamp,
    String? description,
    String? journeyId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      journeyId: journeyId ?? this.journeyId,
    );
  }
}
