// 📌 Model untuk Input Login
class LoginInput {
  final String username;
  final String password;

  LoginInput({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

// 📌 Model untuk Response Login
class LoginResponse {
  final String? token;
  final String? role;
  final String message;
  final int status;

  LoginResponse({
    this.token,
    this.role,
    required this.message,
    required this.status,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        role: json["role"],
        message: json["message"],
        status: json["status"],
      );
}
