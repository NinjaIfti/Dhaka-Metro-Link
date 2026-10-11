import '../../domain/entities/journey.dart';
import '../../domain/repositories/journey_repository.dart';
import '../../core/database/database_helper.dart';
import '../models/journey_model.dart';

class JourneyRepositoryImpl implements JourneyRepository {
  final DatabaseHelper _dbHelper;

  JourneyRepositoryImpl(this._dbHelper);

  @override
  Future<Journey> createJourney(Journey journey) async {
    final db = await _dbHelper.database;
    final journeyModel = JourneyModel.fromEntity(journey);
    await db.insert('journeys', journeyModel.toMap());
    return journey;
  }

  @override
  Future<Journey?> getJourneyById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'journeys',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return JourneyModel.fromMap(maps.first).toEntity();
  }

  @override
  Future<List<Journey>> getJourneysByCardId(String cardId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'journeys',
      where: 'card_id = ?',
      whereArgs: [cardId],
      orderBy: 'start_time DESC',
    );

    return maps.map((map) => JourneyModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<List<Journey>> getJourneysByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'journeys',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_time DESC',
    );

    return maps.map((map) => JourneyModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<List<Journey>> getRecentJourneysByUserId(
    String userId, {
    int limit = 10,
  }) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'journeys',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_time DESC',
      limit: limit,
    );

    return maps.map((map) => JourneyModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<List<Journey>> getOngoingJourneysByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'journeys',
      where: 'user_id = ? AND status = ?',
      whereArgs: [userId, 'ongoing'],
      orderBy: 'start_time DESC',
    );

    return maps.map((map) => JourneyModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<Journey> updateJourney(Journey journey) async {
    final db = await _dbHelper.database;
    final journeyModel = JourneyModel.fromEntity(journey);
    await db.update(
      'journeys',
      journeyModel.toMap(),
      where: 'id = ?',
      whereArgs: [journey.id],
    );
    return journey;
  }

  @override
  Future<Journey> completeJourney(
    String journeyId,
    String endStationId,
    DateTime endTime,
    double fare,
  ) async {
    final db = await _dbHelper.database;

    // Get the journey
    final journey = await getJourneyById(journeyId);
    if (journey == null) {
      throw Exception('Journey not found');
    }

    // Update the journey
    final updatedJourney = journey.copyWith(
      endStationId: endStationId,
      endTime: endTime,
      fare: fare,
      status: JourneyStatus.completed,
    );

    await updateJourney(updatedJourney);
    return updatedJourney;
  }

  @override
  Future<Journey> cancelJourney(String journeyId) async {
    final journey = await getJourneyById(journeyId);
    if (journey == null) {
      throw Exception('Journey not found');
    }

    final updatedJourney = journey.copyWith(
      status: JourneyStatus.cancelled,
    );

    await updateJourney(updatedJourney);
    return updatedJourney;
  }

  @override
  Future<void> deleteJourney(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'journeys',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Journey>> getJourneysByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'journeys',
      where: 'user_id = ? AND start_time >= ? AND start_time <= ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'start_time DESC',
    );

    return maps.map((map) => JourneyModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<List<Journey>> getAllJourneys() async {
    final db = await _dbHelper.database;
    final maps = await db.query('journeys', orderBy: 'start_time DESC');
    return maps.map((map) => JourneyModel.fromMap(map).toEntity()).toList();
  }
}
