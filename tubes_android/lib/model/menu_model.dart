// DIGUNAKAN UNTUK GET ALL DATA
class MenuModel {
  final String id;
  final String menuName;
  final double price;
  final String description;
  final int stock;
  final String menuCategories;

  MenuModel({
    required this.id,
    required this.menuName,
    required this.price,
    required this.description,
    required this.stock,
    required this.menuCategories,
  });

  // Parsing dari JSON
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    print("📩 Parsing JSON Menu: $json"); // Debugging

    return MenuModel(
      id: json["_id"]?.toString() ?? "", // Pastikan ID tidak null
      menuName: json["menu_name"]?.toString() ?? "Unknown",
      price: (json["price"] is num)
          ? (json["price"] as num).toDouble()
          : double.tryParse(json["price"].toString()) ?? 0.0,
      description: json["description"]?.toString() ?? "No description",
      stock: (json["stock"] is num)
          ? (json["stock"] as num).toInt()
          : int.tryParse(json["stock"].toString()) ?? 0,
      menuCategories: json["menu_categories"]?.toString() ?? "Uncategorized",
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "menu_name": menuName,
      "price": price,
      "description": description,
      "stock": stock,
      "menu_categories": menuCategories,
    };
  }

  // Override toString untuk memberikan representasi yang lebih jelas
  @override
  String toString() {
    return 'MenuModel(id: $id, menuName: $menuName, price: $price, description: $description, stock: $stock, menuCategories: $menuCategories)';
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
  final String price;
  final String description;
  final String stock;
  final String menuCategories;

  MenuInput({
    required this.menuName,
    required this.price,
    required this.description,
    required this.stock,
    required this.menuCategories,
  });

  Map<String, dynamic> toJson() {
    return {
      "menu_name": menuName,
      "price": double.tryParse(price) ?? 0.0, // ✅ KONVERSI ke double
      "description": description,
      "stock": int.tryParse(stock) ?? 0, // ✅ KONVERSI ke int
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
