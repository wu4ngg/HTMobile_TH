import 'dart:developer';

import 'package:app/app/data/api.dart';
import 'package:app/app/data/sharepre.dart';
import 'package:app/app/model/product.dart';
import 'package:app/app/model/user.dart';
import 'package:app/app/page/category/categorywidget.dart';
import 'package:app/app/provider/category_provider.dart';
import 'package:app/app/provider/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key, this.model});
  final ProductModel? model;
  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController idController = TextEditingController();
  String imageUrl = "";
  List<CategoryModel> cates = [];
  APIRepository repo = APIRepository();
  CategoryModel? selected;
  Future<void>? future;
  uploadProduct(BuildContext context) async {
    String message = "";
    bool r = false;
    if (nameController.text != "" &&
        descController.text != "" &&
        priceController.text != "" &&
        imageUrlController.text != "") {
      ProductModel model = ProductModel(
        id: widget.model != null ? widget.model!.id ?? "-1" : "",
        name: nameController.text,
        description: descController.text,
        imageURL: imageUrlController.text,
        categoryID: selected != null ? selected!.id! : cates[0].id!,
        categoryName: selected != null ? selected!.name : cates[0].name,
        price: int.parse(priceController.text),
      );
      if (widget.model != null) {
        User usr = await getUser();
        log("edit product");
        r = await repo.editProduct(
            usr.accountId!, await TokenManager.getToken(), model);
      } else {
        log("uplaod product");
        r = await repo.uploadProduct(model, await TokenManager.getToken());
      }
      if (r) {
        message = "Đăng thành công!";
      } else {
        message = "Đăng không thành công!";
      }
    } else {
      message = "Vui lòng nhập đầy đủ thông tin!";
    }
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.model != null) {
      nameController.text = widget.model!.name;
      descController.text = widget.model!.description;
      priceController.text = widget.model!.price.toString();
      imageUrlController.text = widget.model!.imageURL.toString();
      imageUrl = imageUrlController.text;
      idController.text = widget.model!.id!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model == null ? "Thêm sản phẩm" : "Sửa sản phẩm"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: FilledButton(
                          onPressed: () {
                            setState(() {
                              future = uploadProduct(context);
                            });
                          },
                          child: FutureBuilder(
                              future: future,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator()),
                                  );
                                }
                                return Text(
                                    widget.model != null ? "Sửa" : "Thêm");
                              }))),
                ],
              ),
              TextField(
                controller: idController,
                enabled: false,
                decoration: const InputDecoration(label: Text("ID")),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(label: Text("Tên SP")),
              ),
              TextField(
                maxLines: null,
                controller: descController,
                decoration: const InputDecoration(label: Text("Mô tả SP")),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(label: Text("Giá SP")),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<CategoryProvider>(builder: (c, v, ch) {
                cates = v.lst;
                if (widget.model != null && selected == null) {
                  selected =
                      cates.firstWhere((e) => e.id == widget.model!.categoryID);
                }
                return DropdownButton(
                    isExpanded: true,
                    value: selected ?? cates[0],
                    items: cates
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        selected = v;
                      });
                    });
              }),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(label: Text("URL Hình ảnh")),
                onEditingComplete: () {
                  setState(() {
                    imageUrl = imageUrlController.text;
                  });
                },
              ),
              Image.network(
                imageUrl,
                errorBuilder: (context, child, trace) => const Center(
                  child: SizedBox(
                      width: 200,
                      height: 100,
                      child: Icon(Icons.error_outline)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
