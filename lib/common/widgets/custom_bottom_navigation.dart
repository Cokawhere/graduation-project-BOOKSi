import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/Home/home_view.dart';
import '../../features/cart/cart_view.dart';
import '../styles/colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(149, 0, 0, 0),
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        if (index == 0) {
          Get.offAll(() => HomeView());
        } else if (index == 1) {
          Get.offAll(() => Cartview());
        } else if (index == 2) {
          Get.to(() => PlaceholderWidget("Blog"));
        } else if (index == 3) {
          Get.to(() => PlaceholderWidget("Profile"));
        }
      },
      selectedItemColor: AppColors.brown,
      unselectedItemColor: AppColors.teaMilk,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 34),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, size: 34),
          label: "",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.article, size: 34), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person, size: 34), label: ""),
      ],
    );
  }
}
