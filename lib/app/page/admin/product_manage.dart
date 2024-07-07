import 'package:app/app/page/admin/add_product_page.dart';
import 'package:app/app/page/admin/product_admin_item.dart';
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
  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    token = pref.getString('jwt_token') ?? "";
    User usr = User.fromJson(jsonDecode(strUser));
    prods = await repo.getListProduct(usr.accountId ?? "", token);
    setState(() {});
  }
  @override
  void initState() {
    future = getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => AddProductPage()));
      }, child: const Icon(Icons.add),),
      appBar: AppBar(
        title: const Text("Quản lý sản phẩm"),
        actions: [
          IconButton(onPressed: () {
            
          }, icon: const Icon(Icons.home_outlined))
        ],
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(itemCount: prods.length, itemBuilder:(context, index) => ProductAdminItem(model: prods[index]),);
        },
      ),
    );
  }
}