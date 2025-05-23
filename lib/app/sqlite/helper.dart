import 'dart:developer';

import 'package:app/app/model/cart.dart';
import 'package:app/app/model/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class DatabaseHelper{
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'db_product.db');
    print(
        "Đường dẫn database: $databasePath"); // in đường dẫn chứa file database
    return await openDatabase(path, onCreate: _onCreate, version: 3, onUpgrade: _onUpgrade
        // ,
        // onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
        );
  }
  Future<void> _onUpgrade(Database db, int v1, int v2) async{
    await db.execute(
      'CREATE TABLE favorite(id INTEGER PRIMARY KEY, productId integer, name nvarchar(2000), description nvarchar(2000), imageURL nvarchar(3000), categoryID integer, categoryName nvarchar(2000), price integer);'
    );
  }
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE cart(id INTEGER PRIMARY KEY, productId integer, quantity integer, name nvarchar(2000), description nvarchar(2000), imageURL nvarchar(3000), categoryID integer, categoryName nvarchar(2000), price integer);'
    );
    await db.execute(
      'CREATE TABLE favorite(id INTEGER PRIMARY KEY, productId integer, name nvarchar(2000), description nvarchar(2000), imageURL nvarchar(3000), categoryID integer, categoryName nvarchar(2000), price integer);'
    );
  }
  Future<List<CartModel>> getCart() async {
    List<CartModel> tmp = [];
    Database db = await database;
    final carts = await db.query("cart");
    for (var element in carts) {
      tmp.add(CartModel.fromJson(element));
    }
    return tmp;
  }
  Future<void> addToCart(CartModel model) async {
    Database db = await database;
    await db.insert("cart", model.toMap());
  }
  Future<void> removeFromCart(int id) async {
    Database db = await database;
    await db.delete("cart", where: "id = ?", whereArgs: [id]);
  }
  Future<void> clearCart() async {
    Database db = await database;
    await db.delete("cart");
  }
  Future<void> updateQuantity(int quantity, int id) async {
    Database db = await database;
    await db.update("cart", {"quantity": quantity}, where: "id = ?", whereArgs: [id]);
  }
  Future<void> addToFav(ProductModel product) async {
    Database db = await database;
    await db.insert("favorite", {...product.toMap(), 'productId': int.parse(product.id ?? "-1")});
  }
  Future<void> removeFromFav(int id) async {
    Database db = await database;
    await db.delete("favorite", where: "id = ?", whereArgs: [id]);
  }
  Future<List<ProductModel>> getFav() async {
    Database db = await database;
    List<ProductModel> lst = [];
    final res = await db.query("favorite");
    for (var element in res) {
      ProductModel model = ProductModel.fromJson(element);
      lst.add(ProductModel.fromJson(element));
    }
    return lst;
  } 
  Future<void> startOver() async{
    Database db = await database;
    await db.delete("cart");
    await db.delete("favorite");
  }
}