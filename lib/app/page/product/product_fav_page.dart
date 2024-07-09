import 'package:app/app/page/admin/product_admin_item.dart';
import 'package:app/app/provider/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFavPage extends StatefulWidget {
  const ProductFavPage({super.key});

  @override
  State<ProductFavPage> createState() => _ProductFavPageState();
}

class _ProductFavPageState extends State<ProductFavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sản phẩm yêu thích"),),
      body: Consumer<FavoriteProvider>(
        builder: (context, value, child) => ListView.builder(
          itemCount: value.list.length,
          itemBuilder: (context, index) =>
              ProductAdminItem(model: value.list[index], onDelete: () {
                value.removeFromFav(int.parse(value.list[index].id ?? "-1"));
              },),
        ),
      ),
    );
  }
}
