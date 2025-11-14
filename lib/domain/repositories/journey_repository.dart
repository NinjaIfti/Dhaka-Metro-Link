import '../entities/journey.dart';

abstract class JourneyRepository {
  /// Create a new journey
  Future<Journey> createJourney(Journey journey);

  /// Get journey by ID
  Future<Journey?> getJourneyById(String id);

  /// Get all journeys for a card
  Future<List<Journey>> getJourneysByCardId(String cardId);

  /// Get all journeys for a user
  Future<List<Journey>> getJourneysByUserId(String userId);

  /// Get recent journeys for a user (limited)
  Future<List<Journey>> getRecentJourneysByUserId(String userId, {int limit = 10});

  /// Get ongoing journeys for a user
  Future<List<Journey>> getOngoingJourneysByUserId(String userId);

  /// Update journey
  Future<Journey> updateJourney(Journey journey);

  /// Complete journey
  Future<Journey> completeJourney(
    String journeyId,
    String endStationId,
    DateTime endTime,
    double fare,
  );

  /// Cancel journey
  Future<Journey> cancelJourney(String journeyId);

  /// Delete journey
  Future<void> deleteJourney(String id);

  /// Get journeys by date range
  Future<List<Journey>> getJourneysByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get all journeys
  Future<List<Journey>> getAllJourneys();
}
