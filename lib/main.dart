import 'package:booksi/features/profile/controllers/book_controllers.dart';
import 'package:booksi/features/profile/controllers/imagekit_controller.dart';
import 'package:booksi/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

import 'features/splash-screen/view.dart';
import 'firebase_options.dart';

import 'common/styles/colors.dart';
import 'lang/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  Get.put(ProfileController(), permanent: true);
  Get.put(BookController(), permanent: true);
  Get.put(ImageKitController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = GetStorage().read('isDarkMode') ?? false;

    return GetMaterialApp(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.black, elevation: 0),
      ),
      translations: AppTranslations(),
      locale: GetStorage().read('lang') != null
          ? Locale(GetStorage().read('lang'))
          : const Locale('en'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,

      home: SplashView(),
    );
  }
}
