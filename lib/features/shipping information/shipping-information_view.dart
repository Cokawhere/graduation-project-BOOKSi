import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/styles/colors.dart';
import '../cart/cart_view.dart';
import '../order-summary/order-summary-view.dart';
import 'shipping-information_controller.dart';

class ShippingInfoView extends StatelessWidget {
  final ShippingInfoController controller = Get.find<ShippingInfoController>();
  final egyptPhoneRegExp = RegExp(r'^(010|011|012|015)[0-9]{8}$');

  ShippingInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 30),
          onPressed: () => Get.to(CartView()),
        ),
        titleSpacing: 0,
        title: Text(
          'shipping_info'.tr,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.brown,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      SizedBox(height: 40),

                      TextFormField(
                        controller: controller.nameController,

                        decoration: InputDecoration(
                          labelText: 'your_name'.tr,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),

                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          hintText: '',
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(173, 158, 158, 158),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.brown),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'enter_name'.tr : null,
                      ),

                      TextFormField(
                        controller: controller.phoneController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          labelText: 'phone'.tr,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          hintText: '',
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(173, 158, 158, 158),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.brown),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'enter_phone'.tr;
                          } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'phone_numbers_only'.tr;
                          } else if (!RegExp(
                            r'^(010|011|012|015)[0-9]{8}$',
                          ).hasMatch(value)) {
                            return 'invalid_egypt_phone'.tr;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => DropdownButtonFormField<String>(
                                value:
                                    controller.selectedGovernment.value.isEmpty
                                    ? null
                                    : controller.selectedGovernment.value,
                                hint: Text('select_government'.tr),
                                items: controller.governments
                                    .map(
                                      (gov) => DropdownMenuItem(
                                        value: gov,
                                        child: Text(gov),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.updateGovernment(value);
                                  }
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  labelText: 'government'.tr,
                                  labelStyle: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey,
                                  ),

                                  border: UnderlineInputBorder(),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        0,
                                        158,
                                        158,
                                        158,
                                      ),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        0,
                                        177,
                                        116,
                                        87,
                                      ),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        0,
                                        244,
                                        67,
                                        54,
                                      ),
                                    ),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        255,
                                        218,
                                        20,
                                        6,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) => value == null
                                    ? 'choose_government'.tr
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Obx(
                              () => DropdownButtonFormField<String>(
                                value: controller.selectedCity.value.isEmpty
                                    ? null
                                    : controller.selectedCity.value,
                                hint: Text('select_city'.tr),
                                items: controller.Cities.map(
                                  (city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city),
                                  ),
                                ).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedCity.value = value;
                                  }
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  labelText: 'city'.tr,
                                  labelStyle: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey,
                                  ),

                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        0,
                                        158,
                                        158,
                                        158,
                                      ),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        0,
                                        177,
                                        116,
                                        87,
                                      ),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        0,
                                        244,
                                        67,
                                        54,
                                      ),
                                    ),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        255,
                                        218,
                                        20,
                                        6,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    value == null ? 'choose_city'.tr : null,
                              ),
                            ),
                          ),
                        ],
                      ),

                      TextFormField(
                        controller: controller.addressController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          labelText: 'address'.tr,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),

                          hintText: '',
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(173, 158, 158, 158),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.brown),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'enter_address'.tr : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'note'.tr,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.noteController,
                        decoration: InputDecoration(
                          hintText: 'optional_note'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(1, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        Get.to(
                          OrderSummaryView(),
                          arguments: {
                            'shippingInfo': controller.getShippingInfo(),
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 8,
                    ),
                    child: Text(
                      'proceed_order_summary'.tr,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
