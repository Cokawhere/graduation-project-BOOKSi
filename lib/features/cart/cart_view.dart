import 'package:booksi/features/Home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/styles/colors.dart';
import '../../common/widgets/custom_bottom_navigation.dart';
import '../../common/widgets/custom_cart_item.dart';
import '../../common/widgets/drawer.dart';
import '../Home/home_controller.dart';
import '../notifications/widgets/notification_badge.dart';
import '../shipping information/shipping-information_controller.dart';
import '../shipping information/shipping-information_view.dart';
import 'cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final HomeController homeController = Get.find<HomeController>();

  // final ShippingInfoController shippingController = Get.put(
  //   ShippingInfoController(),
  //   permanent: false,
  // );

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      drawer: homeController.currentLocale.value.languageCode == 'ar'
          ? null
          : CustomDrawer(),
      endDrawer: homeController.currentLocale.value.languageCode == 'ar'
          ? CustomDrawer()
          : null,

      appBar: AppBar(
        toolbarHeight: 70,

        centerTitle: true,
        title: Text(
          'my_cart'.tr,

          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.brown,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, size: 30, color: AppColors.brown),
            onPressed: () {
              homeController.currentLocale.value.languageCode == 'ar'
                  ? Scaffold.of(context).openEndDrawer()
                  : Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: NotificationBadge(),
          ),
        ],
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
                Text(
                  'cart_empty'.tr,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 223, 170, 145),
                  ),
                ),
                Text(
                  'add_book_start'.tr,
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
              SizedBox(height: 15),
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
                            hintText: 'promo_code'.tr,
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
                            Get.snackbar("success".tr, 'promo_applied'.tr);
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
                          child: Text(
                            'apply'.tr,
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
                        Text('order_amount'.tr, style: TextStyle(fontSize: 16)),
                        Obx(() {
                          double total = cartController.cartItems.fold(
                            0,
                            (sum, item) =>
                                sum + (item['price'] * item['quantity']),
                          );
                          return Text(
                            'EGP${total.toStringAsFixed(2)}',
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
                        Text(
                          'total_payment'.tr,
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
                            'ُEGP${finalTotal.toStringAsFixed(2)} ($totalItems items)',
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
                      Get.put(ShippingInfoController());
                      Get.to(ShippingInfoView());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'proceed_checkout'.tr,
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
