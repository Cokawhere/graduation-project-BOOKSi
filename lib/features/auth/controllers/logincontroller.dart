import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/styles/colors.dart';
import '../../splash-screen/view.dart';
import '../services/loginserv.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final _authService = AuthService();

  void signInWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter both email and password", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) Get.to(() => SplashView());
    } catch (error) {
      Get.snackbar("Login Failed", error.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.olive, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) Get.to(() => SplashView());
    } catch (error) {
      Get.snackbar("Google Sign-In Failed", error.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
