import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/custom_cart_item.dart';
import 'cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'My Cart',
      //     style: TextStyle(
      //       fontSize: 24,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Get.back(),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.shopping_cart, color: Colors.white),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag,
                  size: 90,
                  color: Color.fromARGB(255, 223, 170, 145),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 223, 170, 145),
                  ),
                ),
                const Text(
                  'Add a book to get started.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 223, 170, 145),
                  ),
                ),
                const SizedBox(height: 180),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              final item = cartController.cartItems[index];
              return CustomCartItem(item: item);
            },
          );
        }
      }),
    );
  }
}
