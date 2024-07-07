import 'dart:convert';

import 'package:app/app/data/api.dart';
import 'package:app/app/model/product.dart';
import 'package:app/app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductAdminItem extends StatefulWidget {
  const ProductAdminItem(
      {super.key, required this.model, this.onDelete, this.onEdit});
  final ProductModel model;
  final Function()? onDelete;
  final Function(ProductModel)? onEdit;
  @override
  State<ProductAdminItem> createState() => _ProductAdminItemState();
}

class _ProductAdminItemState extends State<ProductAdminItem> {
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.model.imageURL,
                            height: 48,
                            width: 48,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress != null
                                    ? const SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Center(
                                            child: SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator())),
                                      )
                                    : child,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  widget.model.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )),
                              ],
                            ),
                            Text(NumberFormat().format(widget.model.price))
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: widget.onEdit != null ? () {
                            widget.onEdit!(widget.model);
                          } : null,
                          icon: const Icon(Icons.edit_outlined)),
                      IconButton(
                          onPressed: widget.onDelete,
                          icon: const Icon(Icons.delete_outline))
                    ],
                  ),
                )
              ],
            ),
            const Divider(),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: const Icon(Icons.description_outlined),
              title: const Text("Mô tả"),
              subtitle: Text(widget.model.description),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: const Icon(Icons.category_outlined),
              title: const Text("Loại sản phẩm"),
              subtitle: Text(widget.model.categoryName),
            )
          ],
        ),
      ),
    );
  }
}
