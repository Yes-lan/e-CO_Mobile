class Beacon {
  final int id;
  final String name;
  final double longitude;
  final double latitude;
  final String type;
  final bool isPlaced;
  final DateTime? placedAt;
  final DateTime? createdAt;
  final String qr;
  final String? description;

  Beacon({
    required this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.type,
    required this.isPlaced,
    this.placedAt,
    this.createdAt,
    required this.qr,
    this.description,
  });

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      id: json['id'] as int,
      name: json['name'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      type: json['type'] as String,
      isPlaced: json['isPlaced'] as bool,
      placedAt: json['placedAt'] != null
          ? DateTime.parse(json['placedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      qr: json['qr'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'type': type,
      'isPlaced': isPlaced,
      'placedAt': placedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'qr': qr,
      'description': description,
    };
  }

  bool get isStart => type == 'start';
  bool get isEnd => type == 'end';
  bool get isCheckpoint => type == 'checkpoint';
}
