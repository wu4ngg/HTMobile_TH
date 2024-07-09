import 'dart:developer';

import 'package:app/app/data/api.dart';
import 'package:app/app/model/cart.dart';
import 'package:app/app/page/cart/cart_item.dart';
import 'package:app/app/provider/product_providers.dart';
import 'package:app/app/provider/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  NumberFormat format = NumberFormat();
  List<CartModel> lst = [];
  List<CartModel> selectList = [];
  Future<void>? future;
  APIRepository repo = APIRepository();
  void revalidateCart(CartProvider provider) {
    future = provider.revalidateCart(false);
  }

  buyProducts(CartProvider value) async {
    bool valid = await repo.purchase(
        selectList
            .map((e) => {"productID": e.productId, "count": e.quantity})
            .toList(),
        await TokenManager.getToken());
    if (valid) {
      for (var element in selectList) {
        value.removeFromCart(element);
      }
        await value.revalidateCart(false);
      selectList.clear();
      setState(() {});
    } else {}
  }

  int sumProduct() {
    int sum = 0;
    for (var element in selectList) {
      sum += element.price * element.quantity;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Consumer<CartProvider>(builder: (context, value, child) {
            if (lst.isEmpty) {
              revalidateCart(value);
            }
            return FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                lst = value.cart;
                if (lst.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_shopping_cart_outlined,
                            size: 36,
                          ),
                          Text(
                            "Không có sản phẩm!",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Text(
                            "Hãy bắt đầu mua hàng bằng cách ấn nút 'Thêm vào giỏ' ở sản phẩm.",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: lst.length,
                    itemBuilder: (context, index) => CartItem(
                          selected:
                              selectList.any((e) => e.id == lst[index].id),
                          model: lst[index],
                          onSelectChange: (p0) {
                            setState(() {
                              if (p0!) {
                                selectList.add(lst[index]);
                              } else {
                                selectList
                                    .removeWhere((e) => e.id == lst[index].id);
                              }
                            });
                          },
                          onDelete: () async {
                            if (selectList.isNotEmpty) {
                              selectList
                                  .removeWhere((e) => e.id == lst[index].id);
                            }
                            await value.removeFromCart(lst[index]);
                            setState(() {
                              future = value.revalidateCart(false);
                            });
                          },
                        ));
              },
            );
          })),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tổng tiền"),
                      Consumer<CartProvider>(builder: (context, value, child) {
                        return Text(
                          format.format(sumProduct()),
                          style: Theme.of(context).textTheme.headlineSmall,
                        );
                      })
                    ],
                  ),
                ),
                Row(
                  children: [
                    Consumer<CartProvider>(builder: (context, value, child) {
                      return IconButton(
                          onPressed: () {
                            value.clearCart();
                            setState(() {
                              selectList.clear();
                            });
                          },
                          icon: const Icon(Icons.delete_forever_outlined));
                    }),
                    Consumer<CartProvider>(builder: (context, value, child) {
                      return FilledButton(
                          onPressed: selectList.isEmpty
                              ? null
                              : () {
                                  buyProducts(value);
                                },
                          child: const Text("Mua"));
                    }),
                    Consumer<CartProvider>(builder: (context, value, child) {
                      return Checkbox(
                          value: selectList.length == lst.length &&
                              selectList.isNotEmpty,
                          onChanged: value.cart.isEmpty
                              ? null
                              : (v) {
                                  setState(() {
                                    if (v!) {
                                      selectList = lst;
                                    } else {
                                      selectList = [];
                                    }
                                  });
                                });
                    }),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
