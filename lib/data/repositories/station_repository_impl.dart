import '../../domain/entities/station.dart';
import '../../domain/repositories/station_repository.dart';
import '../../core/database/database_helper.dart';
import '../models/station_model.dart';

class StationRepositoryImpl implements StationRepository {
  final DatabaseHelper _dbHelper;

  StationRepositoryImpl(this._dbHelper);

  @override
  Future<Station?> getStationById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'stations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return StationModel.fromMap(maps.first).toEntity();
  }

  @override
  Future<List<Station>> getAllStations() async {
    final db = await _dbHelper.database;
    final maps = await db.query('stations', orderBy: 'position ASC');
    return maps.map((map) => StationModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<List<Station>> getStationsByLineId(String lineId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'stations',
      where: 'line_id = ?',
      whereArgs: [lineId],
      orderBy: 'position ASC',
    );

    return maps.map((map) => StationModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<List<Station>> getActiveStations() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'stations',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'position ASC',
    );

    return maps.map((map) => StationModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<List<Station>> getStationsOrderedByPosition(String lineId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'stations',
      where: 'line_id = ?',
      whereArgs: [lineId],
      orderBy: 'position ASC',
    );

    return maps.map((map) => StationModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<Station> createStation(Station station) async {
    final db = await _dbHelper.database;
    final stationModel = StationModel.fromEntity(station);
    await db.insert('stations', stationModel.toMap());
    return station;
  }

  @override
  Future<Station> updateStation(Station station) async {
    final db = await _dbHelper.database;
    final stationModel = StationModel.fromEntity(station);
    await db.update(
      'stations',
      stationModel.toMap(),
      where: 'id = ?',
      whereArgs: [station.id],
    );
    return station;
  }

  @override
  Future<void> deleteStation(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'stations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
