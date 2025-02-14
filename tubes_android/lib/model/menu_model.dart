class MenuModel {
  final String id;
  final String menuName;
  final String image;
  final String price;
  final String description;
  final String stock;
  final String menuCategories;

  MenuModel({
    required this.id,
    required this.menuName,
    required this.image,
    required this.price,
    required this.description,
    required this.stock,
    required this.menuCategories,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        id: json["_id"],
        menuName: json["menu_name"],
        image: json["image"],
        price: json["price"].toString(),
        description: json["description"],
        stock: json["stock"].toString(),
        menuCategories: json["menu_categories"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "menu_name": menuName,
        "image": image,
        "price": price,
        "description": description,
        "stock": stock,
        "menu_categories": menuCategories,
      };
}

// Model untuk input form
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

  Map<String, dynamic> toJson() => {
        "menu_name": menuName,
        "price": price,
        "description": description,
        "stock": stock,
        "menu_categories": menuCategories,
      };
}

// Model untuk response dari API
class MenuResponse {
  final String? insertedId;
  final String message;
  final int status;

  MenuResponse({
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) => MenuResponse(
        insertedId: json["inserted_id"]?["_id"],
        message: json["message"],
        status: json["status"],
      );
}
