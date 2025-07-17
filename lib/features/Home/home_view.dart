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
        extendBody: true,
        extendBodyBehindAppBar: false,
        drawer: _buildDrawer(context),
        appBar: AppBar(
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 70,
              color: const Color.fromARGB(85, 0, 0, 0),
              child: BottomAppBar(
                color: const Color.fromARGB(149, 0, 0, 0),
                elevation: 0,
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
                      icon: Icon(Icons.home_filled, size: 34),
                      label: "home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart, size: 34),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                bool isDark = controller.isDarkMode.value;
                return Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode : Icons.wb_sunny,
                      color: AppColors.brown,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                  ],
                );
              }),
              Obx(
                () => Switch(
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleDarkMode,
                  activeColor: AppColors.teaMilk,
                  activeTrackColor: AppColors.brown,
                  inactiveThumbColor: AppColors.background,
                  inactiveTrackColor: AppColors.brown,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                controller.currentLocale.value.languageCode == 'ar'
                    ? "AR"
                    : "EN",
                style: const TextStyle(
                  fontSize: 25,
                  color: AppColors.brown,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => Switch(
                  value: controller.currentLocale.value.languageCode == 'ar',
                  onChanged: controller.toggleLanguage,
                  activeColor: AppColors.teaMilk,
                  activeTrackColor: AppColors.brown,
                  inactiveThumbColor: AppColors.background,
                  inactiveTrackColor: AppColors.brown,
                ),
              ),
            ],
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
