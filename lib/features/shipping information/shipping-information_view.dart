import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/styles/colors.dart';
import '../cart/cart_view.dart';
import '../order-summary/order-summary-view.dart';
import 'shipping-information_controller.dart';

class ShippingInfoView extends StatelessWidget {
  final ShippingInfoController controller = Get.put(ShippingInfoController());

  ShippingInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 30),
          onPressed: () => Get.off(CartView()),
        ),
        titleSpacing: 0,
        title: const Text(
          'Shipping information',
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
                          labelText: 'Your Name',
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
                            value!.isEmpty ? 'Please enter your name' : null,
                      ),

                      TextFormField(
                        controller: controller.phoneController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),

                          labelText: 'Phone',
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
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your phone' : null,
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
                                hint: const Text('Select Government'),
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
                                  labelText: 'Government',
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
                                    ? 'Please select a government'
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
                                hint: const Text('Select City'),
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
                                  labelText: 'City',
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
                                validator: (value) => value == null
                                    ? 'Please select a city'
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),

                      TextFormField(
                        controller: controller.addressController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          labelText: 'Address',
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
                            value!.isEmpty ? 'Please enter your address' : null,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Note',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.noteController,
                        decoration: InputDecoration(
                          hintText: 'Optional note',
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
                        print('Name: ${controller.nameController.text}');
                        print('Phone: ${controller.phoneController.text}');
                        print(
                          'Government: ${controller.selectedGovernment.value}',
                        );
                        print('City: ${controller.selectedCity.value}');
                        print('Address: ${controller.addressController.text}');
                        print('Note: ${controller.noteController.text}');
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
                    child: const Text(
                      'Proceed to Order Summary',
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
