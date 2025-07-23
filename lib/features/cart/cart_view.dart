import 'package:flutter/material.dart';

class Cartview extends StatelessWidget {
  const Cartview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Cart",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
