import 'package:booksi/common/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../splash-screen/view.dart';
import '../services/loginserv.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final _authService = AuthService();

  void signIn() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter both email and password",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        Get.to(SplashView());
      }
    } catch (error) {
      Get.snackbar(
        "Login Failed",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.teaMilk,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        Get.to(SplashView());
      }
    } catch (error) {
      Get.snackbar(
        "Google Sign-In Failed",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.olive,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
