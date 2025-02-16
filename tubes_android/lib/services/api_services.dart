// import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
import 'package:tubes_android/model/login_model.dart';
import 'package:tubes_android/model/menu_model.dart';
import 'package:tubes_android/model/regis_model.dart';

class ApiServices {
  // final Dio _dio = Dio(
  //   BaseOptions(
  //     baseUrl: "https://bp-tubes-c48fa88ca6a5.herokuapp.com/api",
  //     connectTimeout: const Duration(seconds: 10),
  //     receiveTimeout: const Duration(seconds: 10),
  //     headers: {"Content-Type": "application/json"},
  //   ),
  // );

  final Dio dio = Dio();
  final String _baseUrl = 'https://bp-tubes-c48fa88ca6a5.herokuapp.com/api';

  Future<RegisResponse?> register(RegisInput user) async {
    try {
      final response = await dio.post(
        '$_baseUrl/users/register', // Gunakan _baseUrl agar lebih aman
        data: user.toJson(), // Pastikan data dikirim dengan format JSON
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisResponse.fromJson(response.data);
      } else {
        return RegisResponse(
          status: response.statusCode ?? 500,
          message: response.data["error"] ?? "Registrasi gagal",
        );
      }
    } on DioException catch (e) {
      return RegisResponse(
        status: e.response?.statusCode ?? 500,
        message: e.response?.data?["error"] ?? "Registrasi gagal: ${e.message}",
      );
    } catch (e) {
      return RegisResponse(status: 500, message: "Unexpected error: $e");
    }
  }

  // Future<RegisResponse?> register(RegisInput user) async {
  //   try {
  //     final response = await dio.post(
  //       "/users/register",
  //       data: user.toJson(),
  //     );

  //     return RegisResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       return RegisResponse(
  //         status: e.response?.statusCode ?? 500,
  //         message: e.response?.data["error"] ?? "Registrasi gagal",
  //       );
  //     }
  //     return RegisResponse(status: 500, message: "Network error: ${e.message}");
  //   } catch (e) {
  //     return RegisResponse(status: 500, message: "Unexpected error: $e");
  //   }
  // }

  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post(
        '$_baseUrl/users/login',
        data: login.toJson(),
      );
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return LoginResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // LOGIN
  // Future<LoginResponse?> login(LoginInput login) async {
  //   try {
  //     final response = await dio.post(
  //       "/users/login",
  //       data: login.toJson(),
  //     );

  //     return LoginResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       return LoginResponse(
  //         status: e.response?.statusCode ?? 500,
  //         message: e.response?.data["message"] ?? "Login gagal",
  //         role: null,
  //         token: null,
  //       );
  //     }
  //     return LoginResponse(
  //         status: 500,
  //         message: "Network error: ${e.message}",
  //         role: null,
  //         token: null);
  //   } catch (e) {
  //     return LoginResponse(
  //         status: 500,
  //         message: "Unexpected error: $e",
  //         role: null,
  //         token: null);
  //   }
  // }

  // Fungsi untuk mendapatkan token yang tersimpan setelah login
  // Future<String?> getToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token'); // Ambil token JWT dari local storage
  // }

// Fungsi untuk mendapatkan semua menu
  Future<Iterable<MenuModel>?> getAllMenu() async {
    try {
      var response = await dio.get('$_baseUrl/menu');
      if (response.statusCode == 200) {
        final contactList = (response.data['data'] as List)
            .map((contact) => MenuModel.fromJson(contact))
            .toList();
        return contactList;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<MenuModel?> getMenuById(String id) async {
    try {
      var response = await dio.get('$_baseUrl/menu/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        return MenuModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

// Fungsi untuk menambahkan menu
  Future<MenuResponse?> postMenu(MenuInput ct) async {
    try {
      final response = await dio.post(
        '$_baseUrl/menu/',
        data: ct.toJson(),
      );
      if (response.statusCode == 200) {
        return MenuResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

// Fungsi untuk mengedit menu
  Future<MenuResponse?> putMenu(String id, MenuInput ct) async {
    try {
      final response = await Dio().put(
        '$_baseUrl/menu/$id',
        data: ct.toJson(),
      );
      if (response.statusCode == 200) {
        return MenuResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk menghapus menu
  Future<MenuResponse?> deleteMenu(String id) async {
    try {
      final response = await dio.delete('$_baseUrl/menu/$id');

      if (response.statusCode == 200) {
        return MenuResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // GET ALL MENUS
  // Future<List<MenuModel>?> getAllMenus() async {
  //   try {
  //     final response = await _dio.get("/menu/");

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data["menus"];
  //       return data.map((menu) => MenuModel.fromJson(menu)).toList();
  //     } else {
  //       print("Gagal mengambil data menu: ${response.statusCode}");
  //       return null;
  //     }
  //   } on DioException catch (e) {
  //     print("Error fetching menus: ${e.response?.statusCode} - ${e.message}");
  //     return null;
  //   } catch (e) {
  //     print("Unexpected error: $e");
  //     return null;
  //   }
  // }

  // Fungsi untuk menambahkan menu
  // Future<MenuResponse?> postMenu(MenuInput menu) async {
  //   try {
  //     final response = await _dio.post(
  //       "/menu/",
  //       data: menu.toJson(),
  //     );

  //     return MenuResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       return MenuResponse(
  //         status: e.response?.statusCode ?? 500,
  //         message: e.response?.data["error"] ?? "Gagal menambahkan menu",
  //       );
  //     }
  //     return MenuResponse(status: 500, message: "Network error: ${e.message}");
  //   } catch (e) {
  //     return MenuResponse(status: 500, message: "Unexpected error: $e");
  //   }
  // }

  // Fungsi untuk mengubah menu
  // Future<MenuResponse?> putMenu(String menuId, MenuInput menus) async {
  //   try {
  //     final response = await _dio.put(
  //       "/menu/$menuId",
  //       data: menus.toJson(),
  //     );

  //     return MenuResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       return MenuResponse(
  //         status: e.response?.statusCode ?? 500,
  //         message: e.response?.data["error"] ?? "Gagal memperbarui menu",
  //       );
  //     }
  //     return MenuResponse(status: 500, message: "Network error: ${e.message}");
  //   } catch (e) {
  //     return MenuResponse(status: 500, message: "Unexpected error: $e");
  //   }
  // }

  // Fungsi untuk mengambil menu berdasarkan ID
  // Future<MenuResponse?> getMenuById(String menuId) async {
  //   try {
  //     final response = await _dio.get("/menu/$menuId");

  //     return MenuResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       return MenuResponse(
  //         status: e.response?.statusCode ?? 500,
  //         message: e.response?.data["error"] ?? "Gagal mengambil data menu",
  //       );
  //     }
  //     return MenuResponse(status: 500, message: "Network error: ${e.message}");
  //   } catch (e) {
  //     return MenuResponse(status: 500, message: "Unexpected error: $e");
  //   }
  // }

  // // Fungsi untuk menghapus menu
  // Future<MenuResponse?> deleteMenu(String menuId) async {
  //   try {
  //     final response = await _dio.delete("/menu/$menuId");

  //     return MenuResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       return MenuResponse(
  //         status: e.response?.statusCode ?? 500,
  //         message: e.response?.data["error"] ?? "Gagal menghapus menu",
  //       );
  //     }
  //     return MenuResponse(status: 500, message: "Network error: ${e.message}");
  //   } catch (e) {
  //     return MenuResponse(status: 500, message: "Unexpected error: $e");
  //   }
  // }

  // Fungsi untuk insert menu (dengan otentikasi token)
//   Future<MenuResponse?> insertMenu(MenuInput menu, File imageFile) async {
//     try {
//       String? token = await getToken();
//       if (token == null) {
//         return MenuResponse(status: 401, message: "Unauthorized");
//       }

//       String fileName = imageFile.path.split('/').last;

//       FormData formData = FormData.fromMap({
//         "menu_name": menu.menuName,
//         "price": menu.price,
//         "description": menu.description,
//         "stock": menu.stock,
//         "menu_categories": menu.menuCategories,
//         "Image":
//             await MultipartFile.fromFile(imageFile.path, filename: fileName),
//       });

//       final response = await _dio.post(
//         "/",
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );

//       return MenuResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         return MenuResponse(
//           status: e.response?.statusCode ?? 500,
//           message: e.response?.data["error"] ?? "Failed to insert menu",
//         );
//       }
//       return MenuResponse(status: 500, message: "Network error: ${e.message}");
//     } catch (e) {
//       return MenuResponse(status: 500, message: "Unexpected error: $e");
//     }
//   }
}
