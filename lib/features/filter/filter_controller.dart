import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shop/shopview.dart';

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
    "North Sinai",
  ];

  List<String> conditions = ['New', 'Used'];
  List<String> availableFor = ['Sell', 'Trade'];
  List<String> statusOptions = ['Available', 'Sold', 'Borrowed', 'Traded'];

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

  void toggleStatus(String value) {
    if (selectedStatus.contains(value)) {
      selectedStatus.remove(value);
    } else {
      selectedStatus.add(value);
    }
  }

  void toggleAvailableFor(String value) {
  if (selectedAvailableFor.contains(value)) {
    selectedAvailableFor.remove(value);
  } else {
    selectedAvailableFor.add(value);
  }
}


void resetFilters() {
  selectedGovernorate.value = '';
  selectedCategories.clear();
  priceRange.value = const RangeValues(0, 1000);
  selectedConditions.clear();
  selectedAvailableFor.clear();
  selectedStatus.clear();
  selectedRating.value = '';
}

void applyFiltersAndNavigate() {
  final filters = {
    'governorate': selectedGovernorate.value,
    'categories': selectedCategories.toList(),
    'priceRange': priceRange.value,
    'conditions': selectedConditions.toList(),
    'availableFor': selectedAvailableFor.toList(),
    'status': selectedStatus.toList(),
    'rating': selectedRating.value,
  };


    Get.back(result: filters);
}

}
