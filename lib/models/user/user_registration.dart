class UserRegistration {
  String? name;
  String? email;
  String? password;

  UserRegistration({
    required this.name,
    required this.email,
    required this.password,});

  toJson() => {
    'name': name,
    'email': email,
    'password': password
  };

  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    final user = UserRegistration(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
    return user;
  }
}