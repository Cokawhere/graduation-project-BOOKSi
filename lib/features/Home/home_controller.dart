import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var currentLocale =
      (GetStorage().read('lang') != null
              ? Locale(GetStorage().read('lang'))
              : Get.deviceLocale ?? const Locale('en', 'US'))
          .obs;
  var isDarkMode = false.obs;
  final _storage = GetStorage();
  final String darkModeKey = 'isDarkMode';

  void changeTab(int index) => selectedIndex.value = index;

  void toggleLanguage(bool isArabic) {
    final locale = isArabic
        ? const Locale('ar', 'EG')
        : const Locale('en', 'US');

    currentLocale.value = locale;
    Get.updateLocale(locale);

    GetStorage().write('lang', locale.languageCode);
  }

  @override
  void getMood() {
    isDarkMode.value = _storage.read(darkModeKey) ?? false;
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    _storage.write(darkModeKey, value);

    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
