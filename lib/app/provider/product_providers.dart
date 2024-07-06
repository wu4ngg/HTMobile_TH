import 'package:app/app/model/cart.dart';
import 'package:app/app/sqlite/helper.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier{
  List<CartModel> _cart = [];

  List<CartModel> get cart {
    return _cart;
  }
  final DatabaseHelper helper = DatabaseHelper();
  Future<void> revalidateCart(bool notify) async {
    _cart = await helper.getCart();
    if(notify){
      notifyListeners();
    }
  }
  void setSelectAt(int index, bool value){
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
  addToCart(CartModel prod) async{

    if(_cart.any((e) => e.productId == prod.productId)){
      CartModel tmp = _cart.firstWhere((e) => e.productId == prod.productId);
      await helper.updateQuantity(tmp.quantity + 1, int.parse(tmp.id!));
      await revalidateCart(true);
      return;
    }
    await helper.addToCart(prod);
    _cart.add(prod);
    await revalidateCart(true);
  }
  removeFromCart(CartModel prod) async{
    await helper.removeFromCart(int.parse(prod.id ?? "0"));
    _cart.remove(prod);
    revalidateCart(false);
    notifyListeners();
  }
  void clearCart() async{
    await helper.clearCart();
    _cart.clear();
    notifyListeners();
  }
  void purchase(CartModel prod) async {
    //TODO: tính năng mua
  }
  void purchaseAll() async {
    
  }
}