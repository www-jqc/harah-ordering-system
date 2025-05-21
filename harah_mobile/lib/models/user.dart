class User {
  final int userId;
  final String username;
  final String role;
  final int employeeId;
  final String firstName;
  final String lastName;

  User({
    required this.userId,
    required this.username,
    required this.role,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: int.parse(json['user_id'].toString()),
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      employeeId: int.parse(json['employee_id'].toString()),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'role': role,
      'employee_id': employeeId,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
} 