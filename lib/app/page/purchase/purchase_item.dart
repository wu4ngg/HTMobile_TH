import 'package:app/app/model/purchase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseItem extends StatelessWidget {
  const PurchaseItem({super.key, this.onDelete, required this.model});
  final Function()? onDelete;
  final PurchaseHistoryModel model;
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
                        child: const Center(
                          child: Icon(Icons.receipt_outlined),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Hoá đơn ngày ${model.dateCreated}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "${NumberFormat("##,###.##").format(model.total)} đồng",
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline))
                    ],
                  ),
                )
              ],
            ),
            const Divider(),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: const Icon(Icons.person_outline),
              title: const Text("Người mua"),
              subtitle: Text(model.fullName),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: const Icon(Icons.tag),
              title: const Text("ID Hoá đơn"),
              subtitle: Text(model.id ?? "Không có"),
            ),
          ],
        ),
      ),
    );
  }
}
