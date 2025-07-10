import 'package:booksi/common/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'conroller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splashbackground.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               
                Text(
                  'BOOKSi°',
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 7,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                    fontSize: 65,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: 240,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),

                // Animated Subtext
                Obx(
                  () => AnimatedOpacity(
                    opacity: controller.textVisible.value ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: Text(
                      'splash_subtitle'.tr,
                      style: TextStyle(
                        color: AppColors.orange,
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
                  ),
                ),
                SizedBox(height: 180),
              ],
            ),
          ),

          // Bottom Icon Button
          Positioned(
            bottom: 120,
            right: 170,
            child: GestureDetector(
              onTap: controller.goToLogin,
              child: Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 900),
                  margin: EdgeInsets.only(right: controller.iconOffset.value),
                  child: SvgPicture.asset(
                    'assets/images/arrowsplash.svg',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
