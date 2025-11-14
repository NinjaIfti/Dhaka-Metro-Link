import '../entities/station.dart';

abstract class StationRepository {
  /// Get station by ID
  Future<Station?> getStationById(String id);

  /// Get all stations
  Future<List<Station>> getAllStations();

  /// Get stations by line ID
  Future<List<Station>> getStationsByLineId(String lineId);

  /// Get active stations
  Future<List<Station>> getActiveStations();

  /// Get stations ordered by position
  Future<List<Station>> getStationsOrderedByPosition(String lineId);

  /// Create station
  Future<Station> createStation(Station station);

  /// Update station
  Future<Station> updateStation(Station station);

  /// Delete station
  Future<void> deleteStation(String id);
}
