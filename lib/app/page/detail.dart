import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  User user = User.userEmpty();
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    token = pref.getString('jwt_token') ?? "";
    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  Future<void>? future;
  String token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    future = getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    // create style
    TextStyle mystyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
    return Scaffold(
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Card.filled(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                          ),
                          Text(
                            "Lỗi!",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Text(
                            "Hiện chúng tôi đang bị lỗi, xin thông cảm và đợi chốc lát!",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: false,
                    pinned: false,
                    snap: false,
                    automaticallyImplyLeading: false,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Material(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      titlePadding: const EdgeInsets.all(20),
                      expandedTitleScale: 1.5,
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.imageURL!),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            user.fullName!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        ListTile(
                          leading: const Icon(Icons.tag),
                          title: Text(user.idNumber ?? "null"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: Text(user.phoneNumber!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.wc_outlined),
                          title: Text(user.gender!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.cake_outlined),
                          title: Text(user.birthDay!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: const Text("Năm học"),
                          subtitle: Text(user.schoolYear!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.school),
                          title: const Text("Khoá"),
                          subtitle: Text(user.schoolKey!),
                        ),
                        
                        const Divider(),
                        const Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Text("Tuỳ chọn"),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Icon(Icons.edit_outlined),
                          title: const Text("Chỉnh sửa thông tin cá nhân"),
                          trailing: const Icon(Icons.arrow_right),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Icon(Icons.lock_outline),
                          title: const Text("Đổi mật khẩu"),
                          trailing: const Icon(Icons.arrow_right),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Icon(Icons.favorite_border),
                          title: const Text("Danh sách yêu thích"),
                          trailing: const Icon(Icons.arrow_right),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.code),
                          title: const Text("Khoá JWT"),
                          subtitle: Text(token),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }));
  }
}
