import 'package:app/app/config/const.dart';
import 'package:app/app/data/api.dart';
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
    showDialog(context: context, builder: (c) => Center(child: const CircularProgressIndicator()));
    String token = await APIRepository()
        .login(accountController.text, passwordController.text);
    try{
      var user = await APIRepository().current(token);
      saveUser(user, token);
    } catch(e) {
      Navigator.pop(context);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Mainpage()));
    return token;
  }

  Future<void>? future;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      urlLogo,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                    ),
                    const Text(
                      "ĐĂNG NHẬP VÀO HỆ THỐNG",
                      style: TextStyle(fontSize: 24, color: Colors.blue),
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
                          child: const Text("Login"),
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
                          child: const Text("Register"),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
