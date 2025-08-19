import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Home/home_view.dart';
import '../services/sighupserv.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final isLoading = false.obs;

  String? imageBase64;

  final _authService = AuthService();

  void signUpWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar(
        "",
        "Please fill all fields",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signUpWithEmail(email, password, name);
      if (user != null) Get.to(() => HomeView());
    } catch (e) {
      Get.snackbar(
        "Signup Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) Get.to(() => HomeView());
    } catch (e) {
      Get.snackbar(
        "Google Sign-In Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void signInWithFacebook() async {
    try {
      final user = await _authService.signInWithFacebook();
      if (user != null) Get.to(() => HomeView());
    } catch (e) {
      Get.snackbar(
        "Facebook Sign-In Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
