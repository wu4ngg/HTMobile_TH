import 'package:app/app/data/api.dart';
import 'package:app/app/data/sharepre.dart';
import 'package:app/app/model/user.dart';
import 'package:app/app/page/category/categorywidget.dart';
import 'package:app/app/provider/token_manager.dart';
import 'package:flutter/material.dart';

class AddCatepage extends StatefulWidget {
  const AddCatepage({super.key, this.model});
  final CategoryModel? model;
  @override
  State<AddCatepage> createState() => _AddCatepageState();
}

class _AddCatepageState extends State<AddCatepage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController idController = TextEditingController();
  String imageUrl = "";
  APIRepository repo = APIRepository();
  Future<void>? future;
  upload(BuildContext context) async {
    User usr = await getUser();
    bool valid = false;
    String msg = "";
    if (nameController.text != "" &&
        descController.text != "" &&
        imageController.text != "") {
      CategoryModel cate = CategoryModel(
          id: widget.model != null ? widget.model!.id ?? -1 : -1,
          name: nameController.text,
          desc: descController.text,
          imageURL: imageController.text);
      if (widget.model != null) {
        valid = await repo.editCate(
            usr.accountId!, await TokenManager.getToken(), cate);
      } else {
        valid = await repo.uploadCate(
            cate, await TokenManager.getToken(), usr.accountId!);
      }
      if (valid) {
        msg = "Đăng thành công!";
      } else {
        msg = "Đăng thất bại!";
      }
    } else {
      msg = "Vui lòng nhập đầy đủ thông tin";
    }
    if (context.mounted) {
      if (valid) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  void initState() {
    if (widget.model != null) {
      nameController.text = widget.model!.name;
      descController.text = widget.model!.desc;
      imageController.text = widget.model!.imageURL ?? "";
      imageUrl = widget.model!.imageURL ?? "";
      idController.text = (widget.model!.id ?? -1).toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.model != null ? "Sửa" : "Thêm"} danh mục SP"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: FutureBuilder(
                          future: future,
                          builder: (context, snapshot) {
                            return FilledButton(
                                onPressed: snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? null
                                    : () {
                                        setState(() {
                                          future = upload(context);
                                        });
                                      },
                                child: snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? const Center(
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        widget.model != null ? "Sửa" : "Thêm"));
                          }))
                ],
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(label: Text("ID danh mục")),
                enabled: false
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(label: Text("Tên danh mục")),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(label: Text("Mô tả")),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(label: Text("URL Hình ảnh")),
                onEditingComplete: () {
                  setState(() {
                    imageUrl = imageController.text;
                  });
                },
              ),
              SizedBox(
                height: 10,
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
