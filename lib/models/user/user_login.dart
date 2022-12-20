class UserLogin {
  String? email;
  String? password;

  UserLogin({
    required this.email,
    required this.password,});

  toJson() => {
    'email': email,
    'password': password
  };

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    final user = UserLogin(
      email: json['email'],
      password: json['password'],
    );
    return user;
  }
}