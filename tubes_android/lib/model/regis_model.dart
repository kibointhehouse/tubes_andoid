class RegisInput {
  final String fullname;
  final String phonenumber;
  final String username;
  final String password;

  RegisInput({
    required this.fullname,
    required this.phonenumber,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": fullname,
      "phone_number": phonenumber,
      "username": username,
      "password": password,
    };
  }
}

class RegisResponse {
  final int? status;
  final String message;
  final String? userId;

  RegisResponse({
    required this.status,
    required this.message,
    this.userId,
  });

  factory RegisResponse.fromJson(Map<String, dynamic> json) {
    return RegisResponse(
      status: json["status"],
      message: json["message"] ?? "Unknown error",
      userId: json["user"]?["_id"],
    );
  }
}
