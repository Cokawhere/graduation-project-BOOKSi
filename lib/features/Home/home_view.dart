import 'package:booksi/common/styles/colors.dart';
import 'package:booksi/features/profile/views/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                height: 70,
                color: const Color.fromARGB(144, 0, 0, 0),
                child: BottomAppBar(
                  color: const Color.fromARGB(144, 0, 0, 0),
                  elevation: 0,

                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: const Color.fromARGB(0, 233, 229, 219),
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
}

Widget _buildDrawer(BuildContext context) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final HomeController controller = Get.put(HomeController());

  return Directionality(
    textDirection: TextDirection.ltr,
    child: Drawer(
      width: MediaQuery.of(context).size.width * 0.68,
      child: Obx(
        () => Container(
          color: controller.isDarkMode.value
              ? AppColors.black
              : AppColors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(height: 40),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.teaMilk,
                          child: Icon(
                            Icons.person,
                            color: AppColors.brown,
                            size: 60,
                          ),
                        ),
                        Text(
                          "Hello Loading...",
                          style: TextStyle(
                            color: AppColors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Column(
                      children: [
                        SizedBox(height: 40),

                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.teaMilk,
                          child: Icon(
                            Icons.person,
                            color: AppColors.brown,
                            size: 60,
                          ),
                        ),
                        Text(
                          "Hello No Name",
                          style: TextStyle(
                            color: AppColors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,

                        backgroundColor: AppColors.teaMilk,
                        backgroundImage:
                            userData["photoUrl"] != null &&
                                userData["photoUrl"] != ""
                            ? NetworkImage(userData["photoUrl"])
                            : null,
                        child:
                            userData["photoUrl"] == null ||
                                userData["photoUrl"] == ""
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.brown,
                              )
                            : null,
                      ),
                      SizedBox(height: 10),

                      Text(
                        "Hello ${userData["name"] ?? "No Name"}",
                        style: TextStyle(
                          color: AppColors.brown,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.brightness_6,
                  color: AppColors.brown,
                  size: 25,
                ),
                title: Obx(
                  () => Text(
                    controller.isDarkMode.value ? 'Dark Theme' : 'Light Theme',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing: Obx(
                  () => Switch(
                    value: controller.isDarkMode.value,
                    onChanged: controller.toggleDarkMode,
                    activeColor: AppColors.teaMilk,
                    activeTrackColor: AppColors.brown,
                    inactiveThumbColor: AppColors.background,
                    inactiveTrackColor: AppColors.brown,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.language, color: AppColors.brown, size: 25),
                title: Obx(
                  () => Text(
                    controller.currentLocale.value.languageCode == 'ar'
                        ? 'العربية'
                        : 'English',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing: Obx(
                  () => Switch(
                    value: controller.currentLocale.value.languageCode == 'ar',
                    onChanged: controller.toggleLanguage,
                    activeColor: AppColors.teaMilk,
                    activeTrackColor: AppColors.brown,
                    inactiveThumbColor: AppColors.background,
                    inactiveTrackColor: AppColors.brown,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, color: AppColors.brown, size: 25),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => Get.to(() => ProfilePage()),
              ),
              ListTile(
                leading: Icon(Icons.mail, color: AppColors.brown, size: 25),
                title: Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  // Get.to(() => MessagesView());
                },
              ),
              SizedBox(height: 50),
              ListTile(
                leading: Icon(Icons.logout, color: AppColors.orange, size: 25),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  await AuthService().signOut();
                  Get.offAll(() => LoginView());
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class PlaceholderWidget extends StatelessWidget {
  final String label;
  const PlaceholderWidget(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label, style: TextStyle(fontSize: 22)));
  }
}
