import 'package:app/app/model/cart.dart';
import 'package:app/app/model/product.dart';
import 'package:app/app/page/product/product_info.dart';
import 'package:app/app/provider/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.model});
  final ProductModel model;
  @override
  Widget build(BuildContext context) {
    NumberFormat format = NumberFormat("##,###.##");
    return Card.filled(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductInfoPage(model: model),
              ));
        },
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    child: Material(
                      color: Colors.white,
                      child: Image.network(
                        model.imageURL,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress != null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : child,
                        height: 128,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text("${format.format(model.price)}₫",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            )),
                    Text(model.categoryName)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<CartProvider>(
                            builder: (context, value, child) {
                          return FilledButton(
                            onPressed: () {
                              value.addToCart(CartModel.fromProduct(model));
                            },
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Consumer<FavoriteProvider>(
                        builder: (context, value, child) {
                          return Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if(value.isInList(model)){
                                      await value.removeFromFav(int.parse(model.id!));
                                      return;
                                    }
                                    value.addToFav(model);
                                  },
                                  child: Icon(value.isInList(model) ? Icons.favorite : Icons.favorite_border)));
                        }
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
