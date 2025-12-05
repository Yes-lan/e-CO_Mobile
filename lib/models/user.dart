class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['FirstName'] as String,
      lastName: json['LastName'] as String,
      roles: List<String>.from(json['roles'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'FirstName': firstName,
      'LastName': lastName,
      'roles': roles,
    };
  }

  bool get isTeacher => roles.contains('ROLE_TEACHER') || roles.contains('ROLE_ADMIN');
}
