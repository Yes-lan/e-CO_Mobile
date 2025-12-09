class Session {
  final int id;
  final String sessionName;
  final int nbRunner;
  final int? courseId;
  final String? courseName;
  final DateTime? sessionStart;
  final DateTime? sessionEnd;

  Session({
    required this.id,
    required this.sessionName,
    required this.nbRunner,
    this.courseId,
    this.courseName,
    this.sessionStart,
    this.sessionEnd,
  });

  bool get isActive => sessionStart != null && sessionEnd == null;
  bool get isCompleted => sessionEnd != null;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as int,
      sessionName: (json['sessionName'] ?? json['name']) as String,
      nbRunner: (json['nbRunner'] ?? json['nbRunners'] ?? 0) as int,
      courseId: json['course']?['id'] as int?,
      courseName: json['course']?['name'] as String?,
      sessionStart: json['sessionStart'] != null 
          ? DateTime.parse(json['sessionStart'] as String)
          : null,
      sessionEnd: json['sessionEnd'] != null
          ? DateTime.parse(json['sessionEnd'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionName': sessionName,
      'nbRunner': nbRunner,
      'courseId': courseId,
      'courseName': courseName,
      'sessionStart': sessionStart?.toIso8601String(),
      'sessionEnd': sessionEnd?.toIso8601String(),
    };
  }
}
