// DIGUNAKAN UNTUK GET ALL DATA
class MenuModel {
  final String id;
  final String menuName;
  // final String image;
  final String price;
  final String description;
  final String stock;
  final String menuCategories;

  MenuModel({
    required this.id,
    required this.menuName,
    // required this.image,
    required this.price,
    required this.description,
    required this.stock,
    required this.menuCategories,
  });

  // Parsing dari JSON
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json["_id"] ?? "", // Pastikan ID tidak null
      menuName: json["menu_name"] ?? "Unknown",
      // image: json["image"] ?? "",
      price: json["price"]?.toString() ?? "0", // Jika null, default "0"
      description: json["description"] ?? "No description",
      stock: json["stock"]?.toString() ?? "0", // Jika null, default "0"
      menuCategories: json["menu_categories"] ?? "Uncategorized",
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "menu_name": menuName,
      // "image": image,
      "price": price,
      "description": description,
      "stock": stock,
      "menu_categories": menuCategories,
    };
  }
}

// DIGUNAKAN UNTUK RESPONSE API LIST MENU
class MenuListResponse {
  final List<MenuModel> menus;

  MenuListResponse({
    required this.menus,
  });

  factory MenuListResponse.fromJson(Map<String, dynamic> json) {
    var menuList = json["menus"] as List? ?? [];
    return MenuListResponse(
      menus: menuList.map((item) => MenuModel.fromJson(item)).toList(),
    );
  }
}

// DIGUNAKAN UNTUK FORM INPUT
class MenuInput {
  final String menuName;
  // final String image;
  final String price;
  final String description;
  final String stock;
  final String menuCategories;

  MenuInput({
    required this.menuName,
    // required this.image,
    required this.price,
    required this.description,
    required this.stock,
    required this.menuCategories,
  });

  Map<String, dynamic> toJson() {
    return {
      "menu_name": menuName,
      // "image": image,
      "price": price,
      "description": description,
      "stock": stock,
      "menu_categories": menuCategories,
    };
  }
}

// DIGUNAKAN UNTUK RESPONSE API (Tambah/Edit Menu)
class MenuResponse {
  final String? insertedId;
  final String message;
  final int status;

  MenuResponse({
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    return MenuResponse(
      insertedId: json["inserted_id"]?["_id"], // Pastikan struktur sesuai API
      message: json["message"] ?? "No message",
      status: json["status"] ?? 500, // Default error code jika null
    );
  }
}
