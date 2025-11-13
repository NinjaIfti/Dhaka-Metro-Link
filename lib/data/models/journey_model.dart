import '../../domain/entities/journey.dart';

class JourneyModel {
  final String id;
  final String cardId;
  final String userId;
  final String startStationId;
  final String? endStationId;
  final DateTime startTime;
  final DateTime? endTime;
  final double? fare;
  final JourneyStatus status;

  const JourneyModel({
    required this.id,
    required this.cardId,
    required this.userId,
    required this.startStationId,
    this.endStationId,
    required this.startTime,
    this.endTime,
    this.fare,
    required this.status,
  });

  // Convert from domain entity
  factory JourneyModel.fromEntity(Journey journey) {
    return JourneyModel(
      id: journey.id,
      cardId: journey.cardId,
      userId: journey.userId,
      startStationId: journey.startStationId,
      endStationId: journey.endStationId,
      startTime: journey.startTime,
      endTime: journey.endTime,
      fare: journey.fare,
      status: journey.status,
    );
  }

  // Convert to domain entity
  Journey toEntity() {
    return Journey(
      id: id,
      cardId: cardId,
      userId: userId,
      startStationId: startStationId,
      endStationId: endStationId,
      startTime: startTime,
      endTime: endTime,
      fare: fare,
      status: status,
    );
  }

  // Convert from database map
  factory JourneyModel.fromMap(Map<String, dynamic> map) {
    return JourneyModel(
      id: map['id'] as String,
      cardId: map['card_id'] as String,
      userId: map['user_id'] as String,
      startStationId: map['start_station_id'] as String,
      endStationId: map['end_station_id'] as String?,
      startTime: DateTime.parse(map['start_time'] as String),
      endTime: map['end_time'] != null
          ? DateTime.parse(map['end_time'] as String)
          : null,
      fare: map['fare'] != null ? (map['fare'] as num).toDouble() : null,
      status: _parseStatus(map['status'] as String),
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'card_id': cardId,
      'user_id': userId,
      'start_station_id': startStationId,
      'end_station_id': endStationId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'fare': fare,
      'status': _statusToString(status),
    };
  }

  // Convert from JSON
  factory JourneyModel.fromJson(Map<String, dynamic> json) {
    return JourneyModel(
      id: json['id'] as String,
      cardId: json['cardId'] as String,
      userId: json['userId'] as String,
      startStationId: json['startStationId'] as String,
      endStationId: json['endStationId'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      fare: json['fare'] != null ? (json['fare'] as num).toDouble() : null,
      status: _parseStatus(json['status'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardId': cardId,
      'userId': userId,
      'startStationId': startStationId,
      'endStationId': endStationId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'fare': fare,
      'status': _statusToString(status),
    };
  }

  static JourneyStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return JourneyStatus.ongoing;
      case 'completed':
        return JourneyStatus.completed;
      case 'cancelled':
        return JourneyStatus.cancelled;
      default:
        return JourneyStatus.ongoing;
    }
  }

  static String _statusToString(JourneyStatus status) {
    switch (status) {
      case JourneyStatus.ongoing:
        return 'ongoing';
      case JourneyStatus.completed:
        return 'completed';
      case JourneyStatus.cancelled:
        return 'cancelled';
    }
  }

  JourneyModel copyWith({
    String? id,
    String? cardId,
    String? userId,
    String? startStationId,
    String? endStationId,
    DateTime? startTime,
    DateTime? endTime,
    double? fare,
    JourneyStatus? status,
  }) {
    return JourneyModel(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      userId: userId ?? this.userId,
      startStationId: startStationId ?? this.startStationId,
      endStationId: endStationId ?? this.endStationId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      fare: fare ?? this.fare,
      status: status ?? this.status,
    );
  }
}
