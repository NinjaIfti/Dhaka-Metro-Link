// lib/domain/entities/journey.dart
enum JourneyStatus {
  ongoing,
  completed,
  cancelled,
}

class Journey {
  final String id;
  final String cardId;
  final String userId;
  final String startStationId;
  final String? endStationId; // Null when journey is ongoing
  final DateTime startTime;
  final DateTime? endTime; // Null when journey is ongoing
  final double fare;
  final JourneyStatus status;

  const Journey({
    required this.id,
    required this.cardId,
    required this.userId,
    required this.startStationId,
    this.endStationId,
    required this.startTime,
    this.endTime,
    required this.fare,
    required this.status,
  });

  // Clone the journey with updated fields
  Journey copyWith({
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
    return Journey(
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

  @override
  String toString() {
    return 'Journey(id: $id, cardId: $cardId, userId: $userId, startStationId: $startStationId, endStationId: $endStationId, startTime: $startTime, endTime: $endTime, fare: $fare, status: $status)';
  }
}