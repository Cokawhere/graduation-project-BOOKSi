import 'package:booksi/common/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cart/cart_view.dart';
import '../shop/shopview.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  final List<Widget> pages = [
    ShopView(),
    Cartview(),
    PlaceholderWidget("Blog"),
    PlaceholderWidget("profile"),
  ];

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: false,
        drawer: _buildDrawer(context),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                iconTheme: const IconThemeData(
                  size: 30,
                  color: AppColors.brown,
                ),
                titleSpacing: 0,
                title: const Text(
                  "BOOKSi°",
                  style: TextStyle(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: AppColors.brown,
          unselectedItemColor: AppColors.teaMilk,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 30),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, size: 30),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article, size: 30),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: "",
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.teaMilk),
            accountName: Text("Mohamed Ahmed"),
            accountEmail: Text("example@email.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.teaMilk),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('dark_mode'.tr),
            onTap: () {},
          ),
          Obx(
            () => SwitchListTile(
              secondary: const Icon(Icons.translate),
              title: Text('change_language'.tr),
              value: controller.currentLocale.value.languageCode == 'ar',
              onChanged: controller.toggleLanguage,
              subtitle: Text(
                controller.currentLocale.value.languageCode == 'ar'
                    ? "العربية"
                    : "English",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "book_categories".tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('novels'.tr),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.self_improvement),
            title: Text('self_development'.tr),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.nights_stay),
            title: Text('literature'.tr),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.science),
            title: Text('science'.tr),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('history'.tr),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.auto_stories),
            title: Text('religion'.tr),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.business_center),
            title: Text('business'.tr),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.orange),
            title: Text('logout'.tr, style: TextStyle(color: AppColors.orange)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String label;
  const PlaceholderWidget(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label, style: TextStyle(fontSize: 22)));
  }
}
