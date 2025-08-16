import 'package:booksi/features/Home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/styles/colors.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 240),
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),

              Text(
                'payment_success'.tr,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(HomeView()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'return_to_home'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 240),
            ],
          ),
        ),
      ),
    );
  }
}
