import 'package:flutter/material.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProductScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}