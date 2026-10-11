import '../entities/card.dart';

abstract class CardRepository {
  /// Create a new card
  Future<MetroCard> createCard(MetroCard card);

  /// Get card by ID
  Future<MetroCard?> getCardById(String id);

  /// Get card by card number
  Future<MetroCard?> getCardByNumber(String cardNumber);

  /// Get all cards for a user
  Future<List<MetroCard>> getCardsByUserId(String userId);

  /// Update card
  Future<MetroCard> updateCard(MetroCard card);

  /// Update card balance
  Future<void> updateCardBalance(String cardId, double newBalance);

  /// Delete card
  Future<void> deleteCard(String id);

  /// Get all cards
  Future<List<MetroCard>> getAllCards();

  /// Check if card exists
  Future<bool> cardExists(String id);

  /// Get active cards for user
  Future<List<MetroCard>> getActiveCardsByUserId(String userId);
}
