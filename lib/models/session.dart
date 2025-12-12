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
    DateTime? parseDateTime(String? dateStr) {
      if (dateStr == null) return null;
      try {
        // Format: "2025-12-11 00:33:46" - parser comme heure locale
        final date = DateTime.parse(dateStr.replaceAll(' ', 'T'));
        return date;
      } catch (e) {
        print('⚠️ Erreur parsing date: $dateStr - $e');
        return null;
      }
    }

    return Session(
      id: json['id'] as int,
      sessionName: (json['sessionName'] ?? json['name']) as String,
      nbRunner: (json['nbRunner'] ?? json['nbRunners'] ?? 0) as int,
      courseId: (json['course'] ?? json['parcours'])?['id'] as int?,
      courseName: (json['course'] ?? json['parcours'])?['name'] as String?,
      sessionStart: parseDateTime(json['sessionStart'] ?? json['startDate']),
      sessionEnd: parseDateTime(json['sessionEnd'] ?? json['endDate']),
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
