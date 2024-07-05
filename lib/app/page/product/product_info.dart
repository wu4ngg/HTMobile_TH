import 'package:app/app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              background: Image.network(widget.model.imageURL, fit: BoxFit.fitHeight,),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(widget.model.name, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  Text(format.format(widget.model.price), style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child: FilledButton(onPressed: () {}, child: const Text("Mua ngay"))),
                      const SizedBox(width: 10,),
                      Expanded(child: ElevatedButton.icon(onPressed: () {}, label: Text("Thêm vào giỏ"), icon: Icon(Icons.shopping_cart_outlined),))
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child: Text("Mô tả", style: Theme.of(context).textTheme.bodyLarge,)),
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