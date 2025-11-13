import '../../domain/entities/card.dart';

class CardModel {
  final String id;
  final String cardNumber;
  final double balance;
  final DateTime? lastUsed;
  final bool isActive;
  final String userId;

  const CardModel({
    required this.id,
    required this.cardNumber,
    required this.balance,
    this.lastUsed,
    required this.isActive,
    required this.userId,
  });

  // Convert from domain entity
  factory CardModel.fromEntity(MetroCard card) {
    return CardModel(
      id: card.id,
      cardNumber: card.cardNumber,
      balance: card.balance,
      lastUsed: card.lastUsed,
      isActive: card.isActive,
      userId: card.userId,
    );
  }

  // Convert to domain entity
  MetroCard toEntity() {
    return MetroCard(
      id: id,
      cardNumber: cardNumber,
      balance: balance,
      lastUsed: lastUsed,
      isActive: isActive,
      userId: userId,
    );
  }

  // Convert from database map
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] as String,
      cardNumber: map['card_number'] as String,
      balance: (map['balance'] as num).toDouble(),
      lastUsed: map['last_used'] != null
          ? DateTime.parse(map['last_used'] as String)
          : null,
      isActive: map['is_active'] == 1,
      userId: map['user_id'] as String,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'card_number': cardNumber,
      'balance': balance,
      'last_used': lastUsed?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'user_id': userId,
    };
  }

  // Convert from JSON
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      balance: (json['balance'] as num).toDouble(),
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'] as String)
          : null,
      isActive: json['isActive'] as bool,
      userId: json['userId'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'balance': balance,
      'lastUsed': lastUsed?.toIso8601String(),
      'isActive': isActive,
      'userId': userId,
    };
  }

  CardModel copyWith({
    String? id,
    String? cardNumber,
    double? balance,
    DateTime? lastUsed,
    bool? isActive,
    String? userId,
  }) {
    return CardModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      balance: balance ?? this.balance,
      lastUsed: lastUsed ?? this.lastUsed,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
    );
  }
}
