class AdminModel {
  final String id;
  final String email;
  final String name;
  final String password;

  AdminModel({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  factory AdminModel.fromMap(String id, Map<String, dynamic> map) {
    return AdminModel(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'password': password,
    };
  }
}
