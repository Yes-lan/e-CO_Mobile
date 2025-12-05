class Runner {
  final int id;
  final String name;
  final DateTime departure;
  final DateTime? arrival;
  final int? sessionId;

  Runner({
    required this.id,
    required this.name,
    required this.departure,
    this.arrival,
    this.sessionId,
  });

  factory Runner.fromJson(Map<String, dynamic> json) {
    return Runner(
      id: json['id'] as int,
      name: json['name'] as String,
      departure: DateTime.parse(json['departure'] as String),
      arrival: json['arrival'] != null
          ? DateTime.parse(json['arrival'] as String)
          : null,
      sessionId: json['session']?['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'departure': departure.toIso8601String(),
      'arrival': arrival?.toIso8601String(),
      'sessionId': sessionId,
    };
  }

  bool get hasFinished => arrival != null;

  Duration? get totalTime {
    if (arrival != null) {
      return arrival!.difference(departure);
    }
    return null;
  }
}
