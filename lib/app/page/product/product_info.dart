import 'package:app/app/model/cart.dart';
import 'package:app/app/model/product.dart';
import 'package:app/app/provider/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductInfoPage extends StatefulWidget {
  const ProductInfoPage({super.key, required this.model});
  final ProductModel model;
  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  final NumberFormat format = NumberFormat("##,###.##");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                  tag: 0,
                  child: Image.network(
                    widget.model.imageURL,
                    fit: BoxFit.fitHeight,
                  )),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(widget.model.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  Text(
                    format.format(widget.model.price),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Consumer<CartProvider>(builder: (context, value, child) {
                        return Expanded(
                            child: FilledButton.icon(
                          onPressed: () async {
                            await value
                                .addToCart(CartModel.fromProduct(widget.model));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Đã thêm vào giỏ hàng.")));
                            }
                          },
                          label: const Text("Thêm vào giỏ"),
                          icon: const Icon(Icons.shopping_cart_outlined),
                        ));
                      }),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer<FavoriteProvider>(
                        builder: (context, value, child) {
                          return Expanded(
                              child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if(value.isInList(widget.model)){
                                      await value.removeFromFav(int.parse(widget.model.id ?? "-1"));
                                    } else {
                                      await value.addToFav(widget.model);
                                    }
                                  }, icon: Icon(value.isInList(widget.model) ? Icons.favorite : Icons.favorite_border), label: Text("${value.isInList(widget.model) ? "Đã " : ""}Yêu Thích")));
                        }
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Mô tả",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(widget.model.description)),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
