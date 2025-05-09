// lib/domain/entities/card.dart
class MetroCard {
  final String id;
  final String cardNumber;
  final double balance;
  final DateTime lastUsed;
  final bool isActive;
  final String userId;

  const MetroCard({
    required this.id,
    required this.cardNumber,
    required this.balance,
    required this.lastUsed,
    required this.isActive,
    required this.userId,
  });

  // Clone the card with updated fields
  MetroCard copyWith({
    String? id,
    String? cardNumber,
    double? balance,
    DateTime? lastUsed,
    bool? isActive,
    String? userId,
  }) {
    return MetroCard(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      balance: balance ?? this.balance,
      lastUsed: lastUsed ?? this.lastUsed,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'MetroCard(id: $id, cardNumber: $cardNumber, balance: $balance, lastUsed: $lastUsed, isActive: $isActive, userId: $userId)';
  }
}