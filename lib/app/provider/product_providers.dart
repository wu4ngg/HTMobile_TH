import 'dart:developer';

import 'package:app/app/model/cart.dart';
import 'package:app/app/model/product.dart';
import 'package:app/app/sqlite/helper.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<ProductModel> _list = [];
  DatabaseHelper helper = DatabaseHelper();
  bool isInList(ProductModel model) {
    return _list.any((e) => e.id == model.id);
  }

  List<ProductModel> get list {
    updateFav();
    return _list;
  }

  updateFav() async {
    _list = await helper.getFav();
    notifyListeners();
  }

  Future<void> addToFav(ProductModel product) async {
    await helper.addToFav(product);
    await updateFav();
  }

  Future<void> removeFromFav(int id) async {
    await helper.removeFromFav(id);
    await updateFav();
  }
}

class CartProvider extends ChangeNotifier {
  List<CartModel> _cart = [];

  List<CartModel> get cart {
    return _cart;
  }

  final DatabaseHelper helper = DatabaseHelper();
  Future<void> revalidateCart(bool notify) async {
    _cart = await helper.getCart();
    if (notify) {
      notifyListeners();
    }
  }

  void setSelectAt(int index, bool value) {
    _cart[index].selected = value;
    notifyListeners();
  }

  Future<int> get count async {
    await revalidateCart(false);
    int s = 0;
    for (var element in _cart) {
      s += element.quantity;
    }
    return s;
  }

  int get sum {
    int s = 0;
    for (var element in _cart) {
      s += element.price;
    }
    return s;
  }

  addToCart(CartModel prod) async {
    if (_cart.any((e) => e.productId == prod.productId)) {
      CartModel tmp = _cart.firstWhere((e) => e.productId == prod.productId);
      await helper.updateQuantity(tmp.quantity + 1, int.parse(tmp.id!));
      await revalidateCart(true);
      return;
    }
    await helper.addToCart(prod);
    _cart.add(prod);
    await revalidateCart(true);
  }

  removeFromCart(CartModel prod) async {
    await helper.removeFromCart(int.parse(prod.id ?? "0"));
    _cart.remove(prod);
    revalidateCart(false);
    notifyListeners();
  }

  void clearCart() async {
    await helper.clearCart();
    _cart.clear();
    notifyListeners();
  }

  void purchaseAll() async {}
}
