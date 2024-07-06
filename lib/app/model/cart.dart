import 'package:app/app/model/product.dart';

class CartModel extends ProductModel {
  int quantity;
  int productId;
  bool selected = false;
  CartModel(
      {this.quantity = 1,
      this.productId = -1,
      required super.categoryID,
      required super.categoryName,
      required super.description,
      super.id,
      required super.imageURL,
      required super.name,
      required super.price});
  factory CartModel.fromProduct(ProductModel product){
    return CartModel(categoryID: product.categoryID, categoryName: product.categoryName, description: product.description, imageURL: product.imageURL, name: product.name, price: product.price, productId: int.parse(product.id ?? "-1"));
  }
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        productId: json['productId'] ?? -1,
        id: (json['id'] ?? -1).toString(),
        quantity: json['quantity'] ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        imageURL: json['imageURL'] ?? '',
        categoryID: json['categoryID']?.toInt() ?? 0,
        categoryName: json['categoryName'] ?? '',
        price: json['price']?.toInt() ?? 0);
  }
  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'name': name,
      'description': description,
      'imageURL': imageURL,
      'categoryID': categoryID,
      'categoryName': categoryName,
      'price': price,
      'productId': productId
    };
  }
}
