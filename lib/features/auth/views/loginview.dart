import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../common/styles/colors.dart';
import '../controllers/logincontroller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.70,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: const Color.fromARGB(153, 43, 39, 39),
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BOOkSi°",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'login_title'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'login_subtitle'.tr,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    _buildInputField(
                      hint: 'email'.tr,
                      icon: Icons.email_outlined,
                      controller: controller.emailController,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      hint: 'password'.tr,
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: controller.passwordController,
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teaMilk,
                        minimumSize: Size(double.infinity, 50),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.signInWithEmail,
                      child: Text(
                        'sign_in'.tr,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(202, 255, 255, 255),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'or_continue_with'.tr,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: const Color.fromARGB(202, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _socialButton('assets/images/SVG.svg', () {
                          controller.signInWithGoogle();
                        }),
                        const SizedBox(width: 70),
                        _socialButton('assets/images/face.svg', () {}),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'signup_subtitle'.tr,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed('/signup'),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Text Field Builder
  Widget _buildInputField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: const Color.fromARGB(233, 255, 255, 255)),
        prefixIcon: Icon(icon, color: const Color.fromARGB(249, 255, 255, 255)),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.background),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.background),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(assetPath, width: 40, height: 40),
      ),
    );
  }
}
