import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Home/home_view.dart';
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
      Get.snackbar("Error", "Please enter both email and password", snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) Get.offAll(() => HomeView());
    } catch (error) {
      Get.snackbar("Login Failed", error.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await _authService.signInWithGoogle("");  
      if (user != null) Get.offAll(() => HomeView());
    } catch (error) {
      Get.snackbar("Google Sign-In Failed", error.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithFacebook() async {
    isLoading.value = true;
    try {
      final user = await _authService.signInWithFacebook("");
      if (user != null) Get.offAll(() => ());
    } catch (error) {
      Get.snackbar("Facebook Sign-In Failed", error.toString(), snackPosition: SnackPosition.TOP);
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
