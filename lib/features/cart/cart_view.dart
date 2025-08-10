import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:get/get.dart';
import '../../common/styles/colors.dart';
import '../../common/widgets/custom_bottom_navigation.dart';
import '../../common/widgets/custom_cart_item.dart';
import 'cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Cart',

          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.brown,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 30),
          onPressed: () => Get.back(),
        ),
      ),
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
          return Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: 350,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10),
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return CustomCartItem(item: item);
                  },
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Promo Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(239, 220, 9, 9),
                                width: 5.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.snackbar("Success", "Promo code applied!");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              177,
                              116,
                              87,
                              1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order Amount',
                          style: TextStyle(fontSize: 16),
                        ),
                        Obx(() {
                          double total = cartController.cartItems.fold(
                            0,
                            (sum, item) =>
                                sum + (item['price'] * item['quantity']),
                          );
                          return Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() {
                          double total = cartController.cartItems.fold(
                            0,
                            (sum, item) =>
                                sum + (item['price'] * item['quantity']),
                          );
                          double tax = total * 0.07;
                          double finalTotal = total + tax;
                          int totalItems = cartController.cartItems.fold(
                            0,
                            (sum, item) => sum + (item['quantity'] as int),
                          );
                          return Text(
                            '\$${finalTotal.toStringAsFixed(2)} ($totalItems items)',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      double total = cartController.cartItems.fold(
                        0,
                        (sum, item) => sum + (item['price'] * item['quantity']),
                      );
                      double tax = total * 0.07;
                      double finalTotal = total + tax;

                      FlutterPaymob.instance.payWithCard(
                        context: context,
                        currency: "EGP",
                        amount: finalTotal,
                        onPayment: (response) {
                          bool paymentSuccess =
                              response.success ||
                              (response.responseCode == "APPROVED" &&
                                  (response.transactionID?.isNotEmpty ??
                                      false));

                          final paymentData = {
                            "method": "Paymob",
                            "transactionId": response.transactionID ?? "",
                            "paidAt": paymentSuccess
                                ? DateTime.now().toUtc().toIso8601String()
                                : null,
                            "amount": finalTotal,
                            "currency": "EGP",
                            "status": paymentSuccess ? "paid" : "failed",
                            "message": response.message ?? "",
                            "responseCode": response.responseCode ?? "",
                          };

                          final orderSchema = {
                            "orderId":
                                "ORD-${DateTime.now().millisecondsSinceEpoch}",
                            "userId": "abc123",
                            "status": paymentSuccess ? "paid" : "pending",
                            "createdAt": DateTime.now()
                                .toUtc()
                                .toIso8601String(),
                            "updatedAt": DateTime.now()
                                .toUtc()
                                .toIso8601String(),
                            "items": [
                              {
                                "bookId": "xyz456",
                                "title": "The Subtle Art of Not Giving a F*ck",
                                "price": 150,
                                "quantity": 1,
                                "image": "https://example.com/book.jpg",
                                "author": "Mark Manson",
                              },
                              {
                                "bookId": "abc789",
                                "title": "Atomic Habits",
                                "price": 200,
                                "quantity": 2,
                                "image": "https://example.com/atomic.jpg",
                                "author": "James Clear",
                              },
                            ],
                            "shippingInfo": {
                              "name": "Rana Ahmed",
                              "phone": "0123456789",
                              "address": "شارع النيل، عمارة ٥",
                              "city": "Cairo",
                              "government": "Giza",
                              "note": "لو مش موجودة حط الكتاب عند الجيران",
                            },
                            "payment": paymentData,
                            "totalPrice": finalTotal,
                          };

                          print(jsonEncode(orderSchema));
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
