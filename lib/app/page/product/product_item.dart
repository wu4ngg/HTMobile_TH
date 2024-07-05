import 'package:app/app/model/product.dart';
import 'package:app/app/page/product/product_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.model});
  final ProductModel model;
  @override
  Widget build(BuildContext context) {
    NumberFormat format = NumberFormat("##,###.##");
    return Card.filled(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder:(context) => ProductInfoPage(model: model),));
        },
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              model.imageURL,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress != null
                      ? const Expanded(
                          child: Center(child: CircularProgressIndicator()))
                      : child,
              height: 128,
              fit: BoxFit.cover,
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
                        child: FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 16,
                          ),
                          label: Text("Thêm vào giỏ"),
                        ),
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
