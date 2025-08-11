import 'package:badges/badges.dart' as badges;
import 'package:booksi/features/Home/home_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/styles/colors.dart';
import '../../features/Home/home_controller.dart';
import '../../features/blog/views/blog_view.dart';
import '../../features/cart/cart_controller.dart';
import '../../features/cart/cart_view.dart';
import '../../features/profile/views/profile_view.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final CartController cartController = Get.find<CartController>();

  CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: 70,
            color: const Color.fromARGB(255, 235, 234, 231),
            child: BottomAppBar(
              color: const Color.fromARGB(255, 235, 234, 231),
              elevation: 0,

              child: Obx(
                () => BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: const Color.fromARGB(255, 235, 234, 231),
                  elevation: 0,
                  currentIndex: controller.selectedIndex.value,
                  onTap: (index) {
                    controller.changeTab(index);
                    switch (index) {
                      case 0:
                        Get.off(() => HomeView());
                        break;
                      case 1:
                        Get.off(() => CartView());
                        break;
                      case 2:
                        Get.off(() => BlogView());
                        break;
                      case 3:
                        Get.off(() => ProfilePage());
                        break;
                    }
                  },
                  selectedItemColor: AppColors.brown,
                  unselectedItemColor: AppColors.teaMilk,
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled, size: 34),
                      label: "home",
                    ),
                    BottomNavigationBarItem(
                      icon: badges.Badge(
                        badgeContent: Text(
                          ' ${cartController.cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int)).toString()}',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: AppColors.brown,
                          padding: EdgeInsets.all(5),
                        ),
                        showBadge: cartController.cartItems.isNotEmpty,
                        child: Icon(Icons.shopping_cart, size: 34),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.article, size: 34),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person, size: 34),
                      label: "",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
