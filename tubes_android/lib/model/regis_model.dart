
//DIGUNAKAN UNTUK FORM INPUT
class RegisInput {
  final String fullName;
  final String phoneNumber;
  final String username;
  final String password;

  RegisInput({
    required this.fullName,
    required this.phoneNumber,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "name": fullName,
        "phone_number": phoneNumber,
        "username": username,
        "password": password,
      };
}

//DIGUNAKAN UNTUK RESPONSE
class RegisResponse {
  final String? regisId;
  final String message;
  final int status;

  RegisResponse({
    this.regisId,
    required this.message,
    required this.status,
  });

  factory RegisResponse.fromJson(Map<String, dynamic> json) =>
      RegisResponse(
        regisId: json["id"],
        message: json["message"],
        status: json["status"],
      );
}