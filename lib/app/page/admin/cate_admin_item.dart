import 'package:app/app/page/category/categorywidget.dart';
import 'package:flutter/material.dart';

class CateAdminItem extends StatefulWidget {
  const CateAdminItem({super.key, required this.model, this.onDelete, this.onEdit});
  final CategoryModel model;
  final Function()? onDelete;
  final Function(CategoryModel)? onEdit;
  @override
  State<CateAdminItem> createState() => _CateAdminItemState();
}

class _CateAdminItemState extends State<CateAdminItem> {
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
                            widget.model.imageURL!,
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
              subtitle: Text(widget.model.desc),
            ),
          ],
        ),
      ),
    );
  }
}