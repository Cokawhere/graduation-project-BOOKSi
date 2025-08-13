import 'dart:io' show Platform;

import 'package:booksi/features/blog/controllers/blog_controller.dart';
import 'package:booksi/features/book_details/book_details_view.dart'
    show BookDetailsView;
import 'package:booksi/features/chat/controllers/chat_controller.dart';
import 'package:booksi/features/chat/services/chat_service.dart';
import 'package:booksi/features/notifications/controllers/notification_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'features/Home/home_controller.dart';
import 'features/auth/controllers/logincontroller.dart';
import 'features/cart/cart_controller.dart';
import 'features/profile/controllers/book_controllers.dart';
import 'features/profile/controllers/imagekit_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/notifications/controllers/notification_controller.dart';
import 'features/splash-screen/view.dart';
import 'firebase_options.dart';
import 'common/styles/colors.dart';
import 'lang/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FlutterPaymob.instance.initialize(
    apiKey:
        "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBMk5Ua3lNeXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5XYW1oWm8zWjNEQy1kaFozOExHNnZoOVJXWENNbzdYY0U2NDRzZUoxZzN6OF9tZXBJS1lBUnF6Y2tKTmYzZldVaFBUNHdvU0IxSC1qVUJ5Tjk5QjR0Zw==",
    integrationID: 5226437,
    walletIntegrationId: 654321,
    iFrameID: 946372,
  );

  await GetStorage.init();
  Get.lazyPut(() => ProfileController(), fenix: true);
  Get.lazyPut(() => BookController(), fenix: true);
  Get.lazyPut(() => ImageKitController(), fenix: true);
  Get.lazyPut(() => BlogController(), fenix: true);
  Get.lazyPut(() => ChatController(service: ChatService()), fenix: true);
  Get.lazyPut(() => NotificationController(), fenix: true);
  Get.put(LoginController());
  Get.put(CartController());
  Get.put(HomeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = GetStorage().read('isDarkMode') ?? false;

    return GetMaterialApp(
      getPages: [
        GetPage(
          name: '/book-details',
          page: () {
            final bookId = Get.arguments?['bookId'] as String?;
            return BookDetailsView(bookId: bookId);
          },
        ),
      ],
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,

          elevation: 0,
        ),
        colorScheme: ColorScheme.light(
          surface: const Color.fromARGB(255, 242, 240, 236),
          primary: AppColors.dark,
          secondary: AppColors.background,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.black, elevation: 0),
        colorScheme: ColorScheme.dark(
          surface: const Color.fromARGB(247, 67, 66, 66),
          primary: Colors.white,
          secondary: const Color.fromARGB(255, 64, 47, 5),
        ),
      ),
      translations: AppTranslations(),
      locale: GetStorage().read('lang') != null
          ? Locale(GetStorage().read('lang'))
          : const Locale('en'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
    );
  }
}
