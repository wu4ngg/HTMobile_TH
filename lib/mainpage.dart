import 'dart:convert';
import 'dart:developer';
import 'package:app/app/data/api.dart';
import 'package:app/app/model/category.dart';
import 'package:app/app/model/user.dart';
import 'package:app/app/page/cart.dart';
import 'package:app/app/page/category/categorywidget.dart';
import 'package:app/app/page/detail.dart';
import 'package:app/app/page/product/productwidget.dart';
import 'package:app/app/page/purchase_history.dart';
import 'package:app/app/provider/category_provider.dart';
import 'package:app/app/provider/product_providers.dart';
import 'package:app/app/provider/token_manager.dart';
import 'package:app/app/route/page1.dart';
import 'package:app/app/route/page2.dart';
import 'package:app/app/route/page3.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/page/defaultwidget.dart';
import 'app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedCate = -1;
  late var pages = const [
    ProductPage(),
    PurchaseHistory(),
    CartPage(),
    Detail()
  ];
  User user = User.userEmpty();
  int _selectedIndex = 0;
  APIRepository repo = APIRepository();
  String token = "";
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    user = User.fromJson(await jsonDecode(strUser));
    token = await TokenManager.getToken();
  }

  getCate(CategoryProvider prov) async {
    await prov.updateCategories(token, user.idNumber!);
  }

  @override
  void initState() {
    // TODO: implement initState
    getDataUser();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    return pages[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HL Mobile"),
      ),
      drawer: Consumer<CategoryProvider>(builder: (context, prov, child) {
        getCate(prov);
        return Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    user.imageURL!.length < 5
                        ? const SizedBox()
                        : CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              user.imageURL!,
                            )),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      user.fullName!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Trang chủ'),
                onTap: () {
                  Navigator.pop(context);
                  _selectedIndex = 0;
                  setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.history_outlined),
                title: const Text('Lịch sử mua hàng'),
                onTap: () {
                  Navigator.pop(context);
                  _selectedIndex = 1;
                  setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text('Giỏ hàng'),
                onTap: () {
                  Navigator.pop(context);
                  _selectedIndex = 2;
                  setState(() {});
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Danh mục sản phẩm"),
              ),
              prov.lst.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(),
              ...prov.lst.map((e) => ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedIndex = 0;
                      });
                      prov.currentIndex =
                          prov.lst.indexWhere((e2) => e2.id == e.id);
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(e.imageURL!),
                    ),
                    title: Text(e.name),
                  )),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: const Text('Trang Admin'),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Cài đặt'),
                onTap: () {},
              ),
              user.accountId == ''
                  ? const SizedBox()
                  : ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Đăng xuất'),
                      onTap: () {
                        logOut(context);
                      },
                    ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử mua hàng',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(builder: (context, value, child) {
              return Badge(
                  label: FutureBuilder(
                      future: value.count,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Text((snapshot.data ?? 0).toString());
                      }),
                  child: Icon(Icons.shop));
            }),
            label: 'Giỏ hàng',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'T. Tin người dùng',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
