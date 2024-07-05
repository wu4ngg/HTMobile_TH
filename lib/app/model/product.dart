class ProductModel {
  String? id;
  String name;
  String description;
  String imageURL;
  int price;
  int categoryID;
  String categoryName;
  ProductModel(
      {this.id,
      required this.name,
      required this.description,
      required this.imageURL,
      required this.categoryID,
      required this.categoryName,
      required this.price});
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        imageURL: json['imageURL'] ?? '',
        categoryID: json['categoryID']?.toInt() ?? 0,
        categoryName: json['categoryName'] ?? '',
        price: json['price']?.toInt() ?? 0);
  }
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'imageURL': imageURL,
      'categoryID': categoryID,
      'categoryName': categoryName,
      'price': price
    };
  }
  @override
  String toString() => "$name $description $imageURL $categoryID $categoryName $price";
}