import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var currentLocale = Locale(GetStorage().read('lang') ?? 'en').obs;

  void changeTab(int index) => selectedIndex.value = index;

  void toggleLanguage(bool isArabic) {
    final locale = isArabic
        ? const Locale('ar', 'EG')
        : const Locale('en', 'US');
    currentLocale.value = locale;
    Get.updateLocale(locale);
    GetStorage().write('lang', locale.languageCode);
    Get.forceAppUpdate();
    print("Language changed to ${locale.languageCode}");
  }
}
