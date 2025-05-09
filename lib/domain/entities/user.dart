// lib/domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final List<String> cardIds; // References to MetroCard entities

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    required this.cardIds,
  });

  // Clone the user with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    List<String>? cardIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      cardIds: cardIds ?? this.cardIds,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, createdAt: $createdAt, cardIds: $cardIds)';
  }
}