// lib/domain/entities/station.dart
class Station {
  final String id;
  final String name;
  final String lineId;
  final double latitude;
  final double longitude;
  final bool isActive;
  final int position; // Position in the line

  const Station({
    required this.id,
    required this.name,
    required this.lineId,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.position,
  });

  @override
  String toString() {
    return 'Station(id: $id, name: $name, lineId: $lineId, latitude: $latitude, longitude: $longitude, isActive: $isActive, position: $position)';
  }
}