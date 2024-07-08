class ProductModel {
  String? id;
  String name;
  String description;
  String imageURL;
  int price;
  int categoryID;
  String categoryName;
  int? idFav;
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
        id: (json['id'] ?? -1).toString(),
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        imageURL: json['imageURL'] ?? '',
        categoryID: json['categoryID']?.toInt() ?? 0,
        categoryName: json['categoryName'] ?? '',
        price: json['price']?.toInt() ?? 0);
  }
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageURL': imageURL,
      'categoryID': categoryID,
      'categoryName': categoryName,
      'price': price
    };
  }
  @override
  String toString() => "$id $name $description $imageURL $categoryID $categoryName $price";
}
