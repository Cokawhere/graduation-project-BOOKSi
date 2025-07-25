import 'package:booksi/common/styles/colors.dart';
import 'package:booksi/features/profile/views/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/services/loginserv.dart';
import '../auth/views/loginview.dart';
import '../cart/cart_view.dart';
import '../shop/shopview.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  final List<Widget> pages = [
    ShopView(),
    Cartview(),
    PlaceholderWidget("Blog"),
    ProfilePage(),
  ];

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: false,
        drawer: controller.currentLocale.value.languageCode == 'ar'
            ? null
            : _buildDrawer(context),
        endDrawer: controller.currentLocale.value.languageCode == 'ar'
            ? _buildDrawer(context)
            : null,

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
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, size: 30, color: AppColors.brown),
              onPressed: () {
                controller.currentLocale.value.languageCode == 'ar'
                    ? Scaffold.of(context).openEndDrawer()
                    : Scaffold.of(context).openDrawer();
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: AppColors.brown,
                  size: 30,
                ),
                onPressed: () {
                  // Get.to(() => NotificationsView());
                },
              ),
            ),
          ],
        ),

        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.white),
                  accountName: Text(
                    user?.displayName ?? "No Name",
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    user?.email ?? "No Email",
                    style: const TextStyle(color: AppColors.black),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.teaMilk,
                          )
                        : null,
                  ),
                ),
              ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'chat'.tr,
                  style: const TextStyle(
                    color: AppColors.brown,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 1),
                GestureDetector(
                  onTap: () {
                    // Get.to(() => ChatView());
                  },
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.brown,
                    size: 40,
                  ),
                ),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.orange),
              title: Text(
                'logout'.tr,
                style: const TextStyle(color: AppColors.orange),
              ),
              onTap: () async {
                await AuthService().signOut();
                Get.offAll(() => LoginView());
              },
            ),
          ],
        ),
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
