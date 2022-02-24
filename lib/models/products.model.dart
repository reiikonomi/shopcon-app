import 'dart:convert';

final products = productsFromJson(
    "http://192.168.1.7:4000/api/v1/mistreci/categories/marketplace/products/");

List<Products> productsFromJson(String str) =>
    List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
  Products({
    required this.id,
    required this.productName,
    required this.description,
    required this.createdAt,
    required this.postedBy,
    required this.productImage,
    required this.contactNr,
    required this.category,
  });

  int id;
  String productName;
  String description;
  String createdAt;
  String postedBy;
  String productImage;
  String contactNr;
  String category;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["id"],
        productName: json["product_name"],
        description: json["description"],
        createdAt: json["created_at"],
        postedBy: json["posted_by"],
        productImage: json["product_image"],
        contactNr: json["contact_nr"],
        category: json["category"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "description": description,
        "created_at": createdAt,
        "posted_by": postedBy,
        "product_image": productImage,
        "contact_nr": contactNr,
        "category": category,
      };
}
