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
        backgroundColor: AppColors.white,

        extendBody: true,
        extendBodyBehindAppBar: false,
        drawer: _buildDrawer(context),
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "BOOKSi°",
            style: TextStyle(
              color: AppColors.brown,
              fontWeight: FontWeight.w900,
              fontSize: 35,
            ),
          ),
        ),

        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              color: const Color.fromARGB(85, 0, 0, 0),
              child: BottomAppBar(
                color: const Color.fromARGB(149, 0, 0, 0),
                elevation: 0,
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: const Color.fromARGB(0, 169, 81, 81),
                    elevation: 0,
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
                        icon: Icon(Icons.home_filled, size: 35),
                        label: "home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_cart, size: 35),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.article, size: 35),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person, size: 35),
                        label: "",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
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
              title: Text(''),
              value: controller.currentLocale.value.languageCode == 'ar',
              onChanged: controller.toggleLanguage,
              subtitle: Text(
                controller.currentLocale.value.languageCode == 'ar'
                    ? "AR"
                    : "En",
                style: const TextStyle(fontSize: 22),
              ),
            ),
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
