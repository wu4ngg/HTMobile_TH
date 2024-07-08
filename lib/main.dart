import 'package:app/app/provider/category_provider.dart';
import 'package:app/app/provider/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:app/app/page/auth/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => CategoryProvider(),
    ),
    ChangeNotifierProvider(create: (c) => CartProvider()),
    ChangeNotifierProvider(create: (c) => FavoriteProvider())
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
