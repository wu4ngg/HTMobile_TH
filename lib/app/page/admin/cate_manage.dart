import 'dart:developer';

import 'package:app/app/data/api.dart';
import 'package:app/app/data/sharepre.dart';
import 'package:app/app/model/user.dart';
import 'package:app/app/page/admin/add_cate_page.dart';
import 'package:app/app/page/admin/cate_admin_item.dart';
import 'package:app/app/page/category/categorywidget.dart';
import 'package:app/app/provider/category_provider.dart';
import 'package:app/app/provider/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryManage extends StatefulWidget {
  const CategoryManage({super.key});

  @override
  State<CategoryManage> createState() => _CategoryManageState();
}

class _CategoryManageState extends State<CategoryManage> {
  APIRepository repo = APIRepository();
  List<CategoryModel> lst = [];
  User? usr;
  Future<void>? future;
  getData() async {
    usr = await getUser();
    lst = await repo.getListCategory(
        usr!.accountId!, await TokenManager.getToken());
  }

  deleteData(BuildContext context, CategoryProvider value, int id) async {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              icon: const Icon(Icons.question_mark_outlined),
              title: const Text("Xoá sản phẩm"),
              content: const Text("Bạn có muốn xoá sản phẩm này không?"),
              actions: [
                TextButton(
                    onPressed: () async {
                      String msg = "";
                      bool valid = await repo.removeCate(
                          id, usr!.accountId!, await TokenManager.getToken());
                      if (valid) {
                        msg = "Xoá thành công";
                      } else {
                        msg = "Xoá không thành công";
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        Navigator.pop(context);
                      }
                      setState(() {});
                    },
                    child: const Text("Có")),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: const Text("Không"))
              ],
            ));
  }

  refreshProvider(CategoryProvider value) async {
    await getData();
    await value.updateCategories(
        await TokenManager.getToken(), usr!.accountId!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Consumer<CategoryProvider>(builder: (context, value, child) {
        return FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context, MaterialPageRoute(builder: (c) => AddCatepage()));
            future = refreshProvider(value);
            setState(() {});
          },
          child: const Icon(Icons.add),
        );
      }),
      appBar: AppBar(
        title: const Text("Quản lý danh mục sản phẩm"),
      ),
      body: Consumer<CategoryProvider>(builder: (context, value, child) {
        future = refreshProvider(value);
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: lst.length,
                itemBuilder: (context, index) => CateAdminItem(
                      model: lst[index],
                      onEdit: (ct) async {
                        await Navigator.push(context, MaterialPageRoute(builder: (c) => AddCatepage(model: ct,)));
                        refreshProvider(value);
                        setState(() {
                          
                        });
                      },
                      onDelete: () {
                        deleteData(context, value, lst[index].id!);
                      },
                    ));
          },
        );
      }),
    );
  }
}
