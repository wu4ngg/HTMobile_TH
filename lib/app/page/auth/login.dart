import 'dart:developer';

import 'package:app/app/config/const.dart';
import 'package:app/app/data/api.dart';
import 'package:app/app/page/auth/change_password.dart';
import '../register.dart';
import 'package:app/mainpage.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  login(BuildContext context) async {
    //lấy token (lưu share_preference)
    showDialog(
        context: context,
        builder: (c) => const Center(child: const CircularProgressIndicator()));
    String token = await APIRepository()
        .login(accountController.text, passwordController.text);
    bool valid = false;
    log(token);
    try {
      var user = await APIRepository().current(token);
      valid = await saveUser(user, token);
    } catch (e) {
      log(e.toString());
    }
    if (context.mounted) {
      if (token != "") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Mainpage()));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text("Đăng nhập thất bại")));
      }
    }
    return token;
  }

  Future<void>? future;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Đăng nhập"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    height: 64,
                    urlLogo,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: accountController,
                    decoration: const InputDecoration(
                      labelText: "Account",
                      icon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            future = login(context);
                          });
                        },
                        child: const Text("Đăng nhập"),
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: const Text("Đăng ký"),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const ChangePasswordScreen(
                              forgetPassword: true,
                            )));
              },
              child: const Text("Quên mật khẩu"),
            ),
          ]),
        ));
  }
}
