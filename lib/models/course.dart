class Course {
  final int id;
  final String name;
  final String description;
  final String status;
  final DateTime createAt;
  final DateTime? placementCompletedAt;
  final DateTime updateAt;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createAt,
    this.placementCompletedAt,
    required this.updateAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      status: json['status'] as String,
      createAt: DateTime.parse(json['createdAt'] as String), // Votre API utilise 'createdAt'
      placementCompletedAt: null, // Pas dans votre API actuelle
      updateAt: DateTime.parse(json['updatedAt'] as String), // Votre API utilise 'updatedAt'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'createAt': createAt.toIso8601String(),
      'placementCompletedAt': placementCompletedAt?.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }

  bool get isPlacementReady => status == 'placement_ready' || status == 'completed' || status == 'ready';
  bool get isInProgress => status == 'in_progress';
  bool get isDraft => status == 'draft';
  bool get isReady => status == 'ready';
}
