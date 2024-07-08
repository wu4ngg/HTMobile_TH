import 'package:app/app/page/admin/add_product_page.dart';
import 'package:app/app/page/admin/product_admin_item.dart';
import 'package:app/app/provider/token_manager.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:app/app/data/api.dart';
import 'package:app/app/model/product.dart';
import 'package:app/app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductManagePage extends StatefulWidget {
  const ProductManagePage({super.key});

  @override
  State<ProductManagePage> createState() => _ProductManagePageState();
}

class _ProductManagePageState extends State<ProductManagePage> {
  List<ProductModel> prods = [];
  String token = '';
  APIRepository repo = APIRepository();
  Future<void>? future;
  User? usr;
  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    token = pref.getString('jwt_token') ?? "";
    usr = User.fromJson(jsonDecode(strUser));
    prods = await repo.getListProduct(usr!.accountId ?? "", token);
    setState(() {});
  }

  removeProduct(BuildContext context, int id, int index) async {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              icon: const Icon(Icons.question_mark_outlined),
              title: const Text("Xoá sản phẩm"),
              content: const Text("Bạn có muốn xoá sản phẩm này không?"),
              actions: [
                TextButton(
                    onPressed: () async {
                      String msg = "";
                      String token = await TokenManager.getToken();
                      bool success =
                          await repo.removeProduct(id, usr!.accountId!, token);
                      if (success) {
                        msg = "Xoá thành công";
                      } else {
                        msg = "Lỗi";
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        Navigator.pop(context);
                      }
                      prods.removeAt(index);

                      setState(() {});
                    },
                    child: const Text("Có")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Không"))
              ],
            ));
  }

  @override
  void initState() {
    future = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (c) => AddProductPage()));
          future = getData();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Quản lý sản phẩm"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.home_outlined))
        ],
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: prods.length,
            itemBuilder: (context, index) => ProductAdminItem(
                onEdit: (pro) async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProductPage(
                          model: pro,
                        ),
                      ));
                  getData();
                },
                onDelete: () {
                  removeProduct(
                      context, int.parse(prods[index].id ?? "-1"), index);
                },
                model: prods[index]),
          );
        },
      ),
    );
  }
}
