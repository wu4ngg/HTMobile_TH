import 'package:app/app/page/admin/product_manage.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HLAdmin"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const ProductManagePage()));
            },
            leading: const Icon(Icons.phone_android_outlined),
            title: const Text("Quản lý sản phẩm"),
            trailing: const Icon(Icons.arrow_right),
          ),
          ListTile(
            onTap: () {
              
            },
            leading: const Icon(Icons.category_outlined),
            title: const Text("Quản lý danh mục sản phẩm"),
            trailing: const Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}
