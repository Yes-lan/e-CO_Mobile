class LogSession {
  final int id;
  final String type;
  final DateTime time;
  final double? latitude;
  final double? longitude;
  final String? additionalData;
  final int? runnerId;

  LogSession({
    required this.id,
    required this.type,
    required this.time,
    this.latitude,
    this.longitude,
    this.additionalData,
    this.runnerId,
  });

  factory LogSession.fromJson(Map<String, dynamic> json) {
    return LogSession(
      id: json['id'] as int,
      type: json['type'] as String,
      time: DateTime.parse(json['time'] as String),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      additionalData: json['additionalData'] as String?,
      runnerId: json['runner']?['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'time': time.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'additionalData': additionalData,
      'runnerId': runnerId,
    };
  }
}
