import 'dart:convert';
import 'package:app/app/data/api.dart';
import 'package:app/app/model/product.dart';
import 'package:app/app/page/category/categorywidget.dart';
import 'package:app/app/page/product/product_item.dart';
import 'package:app/app/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, this.cateId = -1});
  final int cateId;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<CategoryModel> categories = [];
  List<ProductModel> prods = [];
  int currentIndex = -1;
  Map<String, dynamic> json = {};
  APIRepository repo = APIRepository();
  bool isLoadingProds = false;
  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    token = pref.getString('jwt_token') ?? "";
    json = jsonDecode(strUser);
    prods = await repo.getListProduct(json['accountId'], token);
    setState(() {});
  }

  getDataById(int id, bool doRerendering) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    token = pref.getString('jwt_token') ?? "";
    json = jsonDecode(strUser);
    prods = [];
    prods = await repo.getProductsByCateid(json['accountId'], id, token);
    if (doRerendering) {
      setState(() {
        isLoadingProds = false;
      });
    }
  }

  Future<void>? future;
  String token = "";
  @override
  void initState() {
    future = getData();
    currentIndex = widget.cateId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Danh mục sản phẩm"),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child:
                    Consumer<CategoryProvider>(builder: (context, prov, child) {
                  prov.updateCategories(token, json['accountId']);
                  return SizedBox(
                      height: 84,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: prov.lst.length + 1,
                        itemBuilder: (context, index) => index == 0
                            ? CategoryWidget(
                              selected: prov.currentIndex == index - 1,
                                data: CategoryModel(
                                    name: "Tất cả sản phẩm", desc: ""),
                                onTap: (p0) {
                                  prov.currentIndex = -1;
                                  getData();
                                },
                              )
                            : CategoryWidget(
                                onTap: (id) {
                                  setState(() {
                                    isLoadingProds = true;
                                    prov.currentIndex = index - 1;
                                    getDataById(id, true);
                                  });
                                },
                                selected: prov.currentIndex == index - 1,
                                data: prov.lst[index - 1]),
                      ));
                }),
              ),
              prods.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Card.filled(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("🤷",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                Text(
                                  "Không có sản phẩm!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const Text(
                                    "Chúng tôi chưa đăng sản phẩm cho loại này 😅")
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : isLoadingProds
                      ? const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SliverGrid.builder(
                          itemCount: prods.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: .55, crossAxisCount: 2),
                          itemBuilder: (context, index) =>
                              ProductItem(model: prods[index]),
                        )
            ],
          );
        });
  }
}
