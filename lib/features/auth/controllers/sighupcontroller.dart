import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../splash-screen/view.dart';
import '../services/sighupserv.dart';


class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final isLoading = false.obs;

  final _authService = AuthService();

  void signUpWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signUpWithEmail(email, password, name);
      if (user != null) Get.to(() => SplashView());
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) Get.to(() => SplashView());
    } catch (e) {
      Get.snackbar("Google Sign-In Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}