import 'dart:developer';

import 'package:app/app/data/api.dart';
import 'package:app/app/data/sharepre.dart';
import 'package:app/app/model/user.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool forgetPasswordMode = false;
  final APIRepository repo = APIRepository();
  changePassword() async {

  }
  forgetPassword(BuildContext context) async {
    User user = await getUser();
    log(user.toJson().toString());
    await repo.forgetPassword(user.accountId!, user.idNumber ?? user.accountId!, newPasswordController.text);
    if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thay đổi mật khẩu thành công!")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(forgetPasswordMode ? "Quên mật khẩu" : "Đổi mật khẩu"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              enabled: !forgetPasswordMode,
              obscureText: true,
              controller: oldPasswordController,
              decoration: const InputDecoration(label: Text("Mật khẩu cũ")),
            ),
            TextField(
              obscureText: true,
              controller: newPasswordController,
              decoration: const InputDecoration(label: Text("Mật khẩu mới")),
            ),
            TextField(
              obscureText: true,
              controller: rePasswordController,
              decoration:
                  const InputDecoration(label: Text("Nhập lại mật khẩu mới")),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                      onPressed: () {
                        if(forgetPasswordMode){
                          forgetPassword(context);
                        } else {
                          changePassword();
                        }
                      }, child: const Text("Hoàn thành")),
                ),
                SizedBox(width: 10,),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            forgetPasswordMode = !forgetPasswordMode;
                          });
                        }, child: Text(!forgetPasswordMode ? "Quên mật khẩu" : "Huỷ"))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
