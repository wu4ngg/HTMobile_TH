import 'package:app/app/page/auth/login.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      // case "/":
      //     return MaterialPageRoute(builder: (_) => const SplashScreen()); //-> tao 1 screen
      case "Login":
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }

  static void pushScreen(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }
}
