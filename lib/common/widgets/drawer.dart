import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booksi/common/styles/colors.dart';
import 'package:booksi/features/chat/views/chat_list_view.dart';
import 'package:booksi/features/profile/views/profile_view.dart';
import 'package:booksi/features/auth/services/loginserv.dart';
import 'package:booksi/features/auth/views/loginview.dart';
import 'package:booksi/features/Home/home_controller.dart';

class CustomDrawer extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.68,
        child: Obx(
          () => Container(
            color: controller.isDarkMode.value ? AppColors.black : AppColors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildHeader("Loading...", null);
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return _buildHeader("No Name", null);
                    }
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    return _buildHeader(userData["name"], userData["photoUrl"]);
                  },
                ),
                const SizedBox(height: 20),
                _buildThemeTile(),
                _buildLanguageTile(),
                _buildNavTile(Icons.person, 'Profile', () => Get.offAll(() => ProfilePage())),
                _buildNavTile(Icons.mail, 'Messages', () {
                  Get.to(() => ChatListView(currentUserId: uid!));
                }),
                const SizedBox(height: 50),
                _buildLogoutTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String? name, String? photoUrl) {
    return Column(
      children: [
        const SizedBox(height: 40),
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.teaMilk,
          backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
              ? NetworkImage(photoUrl)
              : null,
          child: (photoUrl == null || photoUrl.isEmpty)
              ? Icon(Icons.person, size: 60, color: AppColors.brown)
              : null,
        ),
        const SizedBox(height: 10),
        Text(
          "Hello ${name ?? "No Name"}",
          style: const TextStyle(
            color: AppColors.brown,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeTile() {
    return ListTile(
      leading: const Icon(Icons.brightness_6, color: AppColors.brown, size: 25),
      title: Obx(() => Text(
        controller.isDarkMode.value ? 'Dark Theme' : 'Light Theme',
        style: const TextStyle(fontSize: 18, color: AppColors.brown, fontWeight: FontWeight.w600),
      )),
      trailing: Obx(() => Switch(
        value: controller.isDarkMode.value,
        onChanged: controller.toggleDarkMode,
        activeColor: AppColors.teaMilk,
        activeTrackColor: AppColors.brown,
        inactiveThumbColor: AppColors.background,
        inactiveTrackColor: AppColors.brown,
      )),
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      leading: const Icon(Icons.language, color: AppColors.brown, size: 25),
      title: Obx(() => Text(
        controller.currentLocale.value.languageCode == 'ar' ? 'العربية' : 'English',
        style: const TextStyle(fontSize: 18, color: AppColors.brown, fontWeight: FontWeight.w600),
      )),
      trailing: Obx(() => Switch(
        value: controller.currentLocale.value.languageCode == 'ar',
        onChanged: controller.toggleLanguage,
        activeColor: AppColors.teaMilk,
        activeTrackColor: AppColors.brown,
        inactiveThumbColor: AppColors.background,
        inactiveTrackColor: AppColors.brown,
      )),
    );
  }

  Widget _buildNavTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brown, size: 25),
      title: Text(label,
        style: const TextStyle(fontSize: 18, color: AppColors.brown, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout, color: AppColors.orange, size: 25),
      title: const Text(
        'Logout',
        style: TextStyle(fontSize: 18, color: AppColors.orange, fontWeight: FontWeight.w600),
      ),
      onTap: () async {
        await AuthService().signOut();
        Get.offAll(() => LoginView());
      },
    );
  }
}
