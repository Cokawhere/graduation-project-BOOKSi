import 'package:booksi/features/blog/controllers/blog_controller.dart';
import 'package:booksi/features/book_details/book_details_view.dart'
    show BookDetailsView;
import 'package:booksi/features/chat/controllers/chat_controller.dart';
import 'package:booksi/features/chat/services/chat_service.dart';
import 'package:booksi/features/notifications/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/chat_bot/chat_bot_view.dart';
import 'features/Home/home_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/auth/controllers/logincontroller.dart';
import 'features/cart/cart_controller.dart';
import 'features/profile/controllers/book_controllers.dart';
import 'features/profile/controllers/imagekit_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/splash-screen/view.dart';
import 'firebase_options.dart';
import 'common/styles/colors.dart';
import 'lang/app_translations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FlutterPaymob.instance.initialize(
    apiKey:
        'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBMk5Ua3lNeXdpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5XYW1oWm8zWjNEQy1kaFozOExHNnZoOVJXWENNbzdYY0U2NDRzZUoxZzN6OF9tZXBJS1lBUnF6Y2tKTmYzZldVaFBUNHdvU0IxSC1qVUJ5Tjk5QjR0Zw==',
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
  Get.put(NotificationController(), permanent: true);
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
    return ScreenUtilInit(
      designSize: const Size(384, 856),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          getPages: [
            GetPage(
              name: '/book-details',
              page: () {
                final bookId = Get.arguments?['bookId'] as String?;
                return BookDetailsView(bookId: bookId);
              },
            ),
            GetPage(
              name: '/chat-bot',
              page: () {
                final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                return ChatBotView(currentUserId: uid);
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
              surface: Color.fromARGB(255, 242, 240, 236),
              primary: AppColors.dark,
              secondary: AppColors.background,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              elevation: 0,
            ),
            colorScheme: const ColorScheme.dark(
              surface: Color.fromARGB(247, 67, 66, 66),
              primary: Colors.white,
              secondary: Color.fromARGB(255, 64, 47, 5),
            ),
          ),
          translations: AppTranslations(),
          locale: GetStorage().read('lang') != null
              ? Locale(GetStorage().read('lang'))
              : Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          home: const SplashView(),
        );
      },
    );
  }
}
