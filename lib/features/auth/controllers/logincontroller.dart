import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Home/home_view.dart';
import '../services/loginserv.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final _authService = AuthService();


  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  String? get userId => _auth.currentUser?.uid;

  Future<void> logout() async {
    await _auth.signOut();
  }

  void signInWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("error".tr, "please_enter_email_and_password".tr, snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) Get.offAll(() => HomeView());
    } catch (error) {
      Get.snackbar("login_failed".tr, error.toString(), snackPosition: SnackPosition.TOP);
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
      Get.snackbar("google_sign_in_failed".tr, error.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

void signInWithFacebook() async {
  print("Facebook button pressed!"); 
  isLoading.value = true;
  try {
    final user = await _authService.signInWithFacebook("");
    print("Facebook login returned: $user"); 
    if (user != null) Get.offAll(() => HomeView());
  } catch (error) {
    print("Facebook error: $error");
    Get.snackbar("facebook_sign_in_failed".tr, error.toString(), snackPosition: SnackPosition.TOP);
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