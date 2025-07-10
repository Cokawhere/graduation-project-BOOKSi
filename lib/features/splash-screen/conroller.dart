import 'dart:async';

import 'package:get/get.dart';

import '../auth/views/loginview.dart';


class SplashController extends GetxController {
  var textVisible = false.obs;
  var iconOffset = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(milliseconds: 1000), () {
      textVisible.value = true;

      Timer.periodic(const Duration(milliseconds: 1000), (_) {
        if (textVisible.value) {
          iconOffset.value = iconOffset.value == 0 ? 10 : 0;
        }
      });
    });
  }

  void goToLogin() {
    Get.to(LoginView());
  }
}
