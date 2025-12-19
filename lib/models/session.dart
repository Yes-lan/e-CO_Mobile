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
        final date = DateTime.parse(dateStr.replaceAll(' ', 'T'));
        return date;
      } catch (e) {
        print('⚠️ Erreur parsing date: $dateStr - $e');
        return null;
      }
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    Map<String, dynamic>? courseMap;
    if (json['course'] != null && json['course'] is Map<String, dynamic>) {
      courseMap = json['course'] as Map<String, dynamic>;
    } else if (json['parcours'] != null && json['parcours'] is Map<String, dynamic>) {
      courseMap = json['parcours'] as Map<String, dynamic>;
    }

    return Session(
      id: parseInt(json['id']),
      sessionName: (json['sessionName'] ?? json['name'] ?? '') as String,
      nbRunner: parseInt(json['nbRunner'] ?? json['nbRunners']),
      courseId: courseMap != null ? parseInt(courseMap['id']) : null,
      courseName: courseMap != null ? courseMap['name'] as String? : null,
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
