import '../../domain/entities/station.dart';

class StationModel {
  final String id;
  final String name;
  final String lineId;
  final double latitude;
  final double longitude;
  final int position;
  final bool isActive;

  const StationModel({
    required this.id,
    required this.name,
    required this.lineId,
    required this.latitude,
    required this.longitude,
    required this.position,
    required this.isActive,
  });

  // Convert from domain entity
  factory StationModel.fromEntity(Station station) {
    return StationModel(
      id: station.id,
      name: station.name,
      lineId: station.lineId,
      latitude: station.latitude,
      longitude: station.longitude,
      position: station.position,
      isActive: station.isActive,
    );
  }

  // Convert to domain entity
  Station toEntity() {
    return Station(
      id: id,
      name: name,
      lineId: lineId,
      latitude: latitude,
      longitude: longitude,
      position: position,
      isActive: isActive,
    );
  }

  // Convert from database map
  factory StationModel.fromMap(Map<String, dynamic> map) {
    return StationModel(
      id: map['id'] as String,
      name: map['name'] as String,
      lineId: map['line_id'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      position: map['position'] as int,
      isActive: map['is_active'] == 1,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'line_id': lineId,
      'latitude': latitude,
      'longitude': longitude,
      'position': position,
      'is_active': isActive ? 1 : 0,
    };
  }

  // Convert from JSON
  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      lineId: json['lineId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      position: json['position'] as int,
      isActive: json['isActive'] as bool,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lineId': lineId,
      'latitude': latitude,
      'longitude': longitude,
      'position': position,
      'isActive': isActive,
    };
  }

  StationModel copyWith({
    String? id,
    String? name,
    String? lineId,
    double? latitude,
    double? longitude,
    int? position,
    bool? isActive,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lineId: lineId ?? this.lineId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
    );
  }
}
