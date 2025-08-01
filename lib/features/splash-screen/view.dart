import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../common/styles/colors.dart';
import '../auth/views/loginview.dart';
import '../auth/views/sighup.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.brown,
              AppColors.teaMilk,
              AppColors.brown,
              AppColors.teaMilk,
              AppColors.brown,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 200),
              Text(
                'BOOKSi°',
                style: TextStyle(
                  color: AppColors.orange,
                  shadows: [
                    Shadow(
                      blurRadius: 7,
                      color: AppColors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                  fontSize: 65,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 5),
              //   width: 240,
              //   height: 4,
              //   decoration: BoxDecoration(
              //     color: AppColors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         blurRadius: 7,
              //         color: AppColors.black,
              //         offset: Offset(2, 2),
              //       ),
              //     ],
              //   ),
              // ),
              Text(
                'splash_subtitle'.tr,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 251, 248),
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: const Color.fromARGB(255, 229, 119, 8),
                      offset: Offset(2, 2),
                    ),
                  ],
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 250),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  minimumSize: const Size(330, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.to(() => SignupView()),
                child: Text(
                  'create_account'.tr,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.brown,

                  minimumSize: const Size(330, 55),
                  side: BorderSide(color: AppColors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.to(() => LoginView()),
                child: Text(
                  'sign_in'.tr,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
