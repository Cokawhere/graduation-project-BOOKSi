import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../common/styles/colors.dart';
import '../controllers/sighupcontroller.dart';
import 'loginview.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 245, 118, 59),
            AppColors.white,
            Color.fromARGB(255, 245, 118, 59),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 100.w,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                SizedBox(width: 15.w),

                Icon(Icons.arrow_back_ios, color: Colors.black),
                SizedBox(width: 1.w),
                Text(
                  "Back",
                  style: TextStyle(color: Colors.black, fontSize: 23.sp),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 134.h),

                    Container(
                      width: MediaQuery.of(context).size.width * 100.w,
                      height: MediaQuery.of(context).size.height * 0.75.h,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/logo.png', height: 60),

                            Text(
                              'signup_subtitle'.tr,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildInputField(
                              hint: 'full_name'.tr,
                              icon: Icons.person,
                              controller: controller.nameController,
                            ),
                            const SizedBox(height: 16),
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
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 245, 118, 59),
                                      AppColors.white,
                                      Color.fromARGB(255, 245, 118, 59),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      0,
                                      196,
                                      164,
                                      132,
                                    ),
                                    shadowColor: Colors.transparent,

                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: controller.signUpWithEmail,
                                  child: Text(
                                    'sign_up'.tr,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: AppColors.black),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'or_continue_with'.tr,
                                    style: TextStyle(color: AppColors.black),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: AppColors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _socialButton(
                                  'assets/images/SVG.svg',
                                  controller.signInWithGoogle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'already_have_account'.tr,
                                  style: TextStyle(color: AppColors.black),
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(LoginView()),
                                  child: Text(
                                    'sign_in_now'.tr,
                                    style: TextStyle(
                                      color: AppColors.black,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.black),
        prefixIcon: Icon(icon, color: AppColors.black),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
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
          border: Border.all(color: AppColors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(assetPath, width: 40, height: 40),
      ),
    );
  }
}
