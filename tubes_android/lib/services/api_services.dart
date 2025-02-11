import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
import 'package:tubes_android/model/login_model.dart';
import 'package:tubes_android/model/regis_model.dart';

class ApiServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://bp-tubes-c48fa88ca6a5.herokuapp.com/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<RegisResponse?> register(RegisInput user) async {
    try {
      final response = await _dio.post(
        "/users/register",
        data: user.toJson(),
      );

      return RegisResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return RegisResponse(
          status: e.response?.statusCode ?? 500,
          message: e.response?.data["error"] ?? "Registrasi gagal",
        );
      }
      return RegisResponse(status: 500, message: "Network error: ${e.message}");
    } catch (e) {
      return RegisResponse(status: 500, message: "Unexpected error: $e");
    }
  }

  // LOGIN
  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await _dio.post(
        "/users/login",
        data: login.toJson(),
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return LoginResponse(
          status: e.response?.statusCode ?? 500,
          message: e.response?.data["message"] ?? "Login gagal",
          role: null,
          token: null,
        );
      }
      return LoginResponse(
          status: 500,
          message: "Network error: ${e.message}",
          role: null,
          token: null);
    } catch (e) {
      return LoginResponse(
          status: 500,
          message: "Unexpected error: $e",
          role: null,
          token: null);
    }
  }
}
