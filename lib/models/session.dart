class Session {
  final int id;
  final String sessionName;
  final int nbRunner;
  final int? courseId;

  Session({
    required this.id,
    required this.sessionName,
    required this.nbRunner,
    this.courseId,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as int,
      sessionName: json['sessionName'] as String,
      nbRunner: json['nbRunner'] as int,
      courseId: json['course']?['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionName': sessionName,
      'nbRunner': nbRunner,
      'courseId': courseId,
    };
  }
}
