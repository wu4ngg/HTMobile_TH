import 'dart:developer';

import 'package:app/app/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {super.key,
      required this.model,
      this.onSelectChange,
      this.onDelete,
      this.selected});
  final CartModel model;
  final Function(bool?)? onSelectChange;
  final Function()? onDelete;
  final bool? selected;
  @override
  Widget build(BuildContext context) {
    log("in widget: ${selected}");
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        model.imageURL,
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
                              model.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            )),
                          ],
                        ),
                        Text(NumberFormat().format(model.price))
                      ],
                    ),
                  ),
                  Text(
                    "x${model.quantity.toString()}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Checkbox(
                      value: selected,
                      onChanged: (val) {
                        if (onSelectChange != null) {
                          onSelectChange!(val);
                        }
                      }),
                  IconButton(
                      onPressed: onDelete, icon: Icon(Icons.delete_outline))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
