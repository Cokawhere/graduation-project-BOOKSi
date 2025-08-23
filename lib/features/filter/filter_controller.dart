import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shop/shop_controller.dart';

class FilterController extends GetxController {
  RxList<String> selectedCategories = <String>[].obs;
  Rx<RangeValues> priceRange = const RangeValues(0, 1000).obs;
  RxString selectedGovernorate = ''.obs;
  RxList<String> selectedConditions = <String>[].obs;
  RxList<String> selectedAvailableFor = <String>[].obs;
  RxList<String> selectedStatus = <String>[].obs;
  RxString selectedRating = ''.obs;

  final List<String> allCategories = [
    "Fiction",
    "Fantasy",
    "Science Fiction",
    "Mystery & Thriller",
    "Romance",
    "Historical",
    "Young Adult",
    "Horror",
    "Biography",
    "Personal Growth",
  ];

  final List<String> egyptGovernorates = [
    "Cairo",
    "Giza",
    "Alexandria",
    "Dakahlia",
    "Red Sea",
    "Beheira",
    "Fayoum",
    "Gharbia",
    "Ismailia",
    "Monufia",
    "Minya",
    "Qalyubia",
    "New Valley",
    "Suez",
    "Aswan",
    "Assiut",
    "Beni Suef",
    "Port Said",
    "Damietta",
    "Sharqia",
    "South Sinai",
    "Kafr El Sheikh",
    "Matruh",
    "Luxor",
    "Qena",
    'Sohag',
    "North Sinai",
  ];

  List<String> conditions = ['New', 'Used'];
  List<String> availableFor = ['Sell', 'Swap'];

  @override
  void onInit() {
    super.onInit();
    final previousFilters = Get.arguments as Map<String, dynamic>?;
    if (previousFilters != null) {
      selectedGovernorate.value = previousFilters['governorate'] ?? '';
      selectedCategories.value = List<String>.from(
        previousFilters['categories'] ?? [],
      );
      priceRange.value =
          previousFilters['priceRange'] ?? const RangeValues(0, 1000);
      selectedConditions.value = List<String>.from(
        previousFilters['conditions'] ?? [],
      );
      selectedAvailableFor.value = List<String>.from(
        previousFilters['availableFor'] ?? [],
      );
      selectedRating.value = previousFilters['rating'] ?? '';
    }
  }

  void updatePriceRange(RangeValues values) {
    priceRange.value = values;
  }

  void toggleCategory(String genre) {
    if (selectedCategories.contains(genre)) {
      selectedCategories.remove(genre);
    } else {
      selectedCategories.add(genre);
    }
  }

  void toggleCondition(String value) {
    if (selectedConditions.contains(value)) {
      selectedConditions.remove(value);
    } else {
      selectedConditions.add(value);
    }
    selectedConditions.refresh();
  }

  void toggleAvailableFor(String value) {
    if (selectedAvailableFor.contains(value)) {
      selectedAvailableFor.remove(value);
    } else {
      selectedAvailableFor.add(value);
    }
  }

  void resetFilters() {
    print("hhhhh");
    selectedGovernorate.value = '';
    selectedCategories.clear();
    priceRange.value = const RangeValues(0, 1000);
    selectedAvailableFor.clear();
    selectedRating.value = '';
    selectedConditions.clear();

    final shopController = Get.find<ShopController>();
    shopController.applyFilters(null);

    try {
      final shopController = Get.find<ShopController>();
      shopController.applyFilters(null);
      print("applyFilters(null) called in ShopController");

      // ScaffoldMessenger.of(Get.context!).showSnackBar(
      //   SnackBar(
      //     content: Text("All filters have been cleared"),
      //     duration: Duration(seconds: 3),
      //   ),
      // );
    } catch (e) {
      print("Error in resetFilters: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("Error resetting filters: $e"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void applyFiltersAndNavigate() {
    final filters = {
      'governorate': selectedGovernorate.value,
      'categories': selectedCategories.toList(),
      'priceRange': priceRange.value,
      'conditions': selectedConditions.toList(),
      'availableFor': selectedAvailableFor.toList(),
      'rating': selectedRating.value,
    };

    Get.back(result: filters);
    // Get.snackbar(
    //   "Success",
    //   "Filters applied successfully!",
    //   snackPosition: SnackPosition.BOTTOM,

    // );
  }
}
