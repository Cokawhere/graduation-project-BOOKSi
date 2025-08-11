import 'package:booksi/features/shipping%20information/shipping-information_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/styles/colors.dart';
import '../../common/widgets/carditem-for-order-summary.dart';
import '../../features/cart/cart_controller.dart';
import '../../features/shipping information/shipping-information_controller.dart';
import 'order-summary-controller.dart';

class OrderSummaryView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final ShippingInfoController shippingController =
      Get.find<ShippingInfoController>();
  final OrderSummaryController orderController = Get.put(
    OrderSummaryController(),
  );

  OrderSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final shippingInfo =
        Get.arguments?['shippingInfo'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 30),
          onPressed: () => Get.offAll(ShippingInfoView()),
        ),
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.brown,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 187,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shippingInfo['name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${shippingInfo['city'] ?? ''}, ${shippingInfo['government'] ?? ''}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text(
                        shippingInfo['phone'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 35, 30, 138),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Get.to(ShippingInfoView()),
                            child: Text(
                              'CHANGE',
                              style: TextStyle(
                                color: AppColors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Obx(() {
                  double total = cartController.cartItems.fold(
                    0,
                    (sum, item) => sum + (item['price'] * item['quantity']),
                  );
                  int totalItems = cartController.cartItems.fold(
                    0,
                    (sum, item) => sum + (item['quantity'] as int),
                  );
                  return Text(
                    'Items $totalItems',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(0),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return CustomCartItemOrderSummary(item: item);
                },
              ),
            ),
            SizedBox(height: 10),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            'Price ($totalItems items)',
                            style: TextStyle(fontSize: 20),
                          );
                        }),
                        SizedBox(height: 5),
                        Obx(() {
                          double total = cartController.cartItems.fold(
                            0,
                            (sum, item) =>
                                sum + (item['price'] * (item['quantity'] ?? 1)),
                          );
                          return Text(
                            'EGP ${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Charges',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Free',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() {
                          double total = cartController.cartItems.fold(
                            0,
                            (sum, item) =>
                                sum + (item['price'] * (item['quantity'] ?? 1)),
                          );
                          double finalTotal = total;
                          return Text(
                            'EGP ${finalTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ElevatedButton(
                  onPressed: () => orderController.processPaymentAndSaveOrder(
                    shippingInfo,
                    cartController.cartItems.fold(
                      0,
                      (sum, item) => sum + (item['price'] * item['quantity']),
                    ),
                    context,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
