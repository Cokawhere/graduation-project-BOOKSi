import 'package:booksi/common/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'filter_controller.dart';

class FilterView extends StatelessWidget {
  FilterView({super.key});

  final FilterController controller = Get.put(
    FilterController(),
    tag: "filter",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 25),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          "Filter",
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Location",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),

            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedGovernorate.value == ''
                    ? null
                    : controller.selectedGovernorate.value,
                onChanged: (val) {
                  controller.selectedGovernorate.value = val!;
                },
                items: controller.egyptGovernorates
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(0, 226, 221, 221),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(239, 238, 238, 0),
                      width: 0,
                    ),
                  ),
                  hintText: 'Select Location',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(0, 214, 5, 5),
                  ),
                ),
                dropdownColor: AppColors.white,

                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 50,
              child: Obx(() {
                final selected = controller.selectedCategories.value;
                final categories = controller.allCategories;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final genre = categories[index];
                    final isSelected = selected.contains(genre);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: GestureDetector(
                        onTap: () => controller.toggleCategory(genre),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            color: isSelected
                                ? AppColors.brown
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: const Color.fromARGB(0, 177, 116, 87),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 16),

            const Text(
              "Price Range",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Obx(() {
              return SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  activeTrackColor: AppColors.brown,
                  inactiveTrackColor: const Color.fromARGB(255, 238, 232, 219),
                  thumbColor: AppColors.brown,
                  overlayColor: AppColors.brown,
                ),
                child: RangeSlider(
                  values: controller.priceRange.value,
                  onChanged: (RangeValues values) {
                    controller.updatePriceRange(values);
                  },
                  min: 0,
                  max: 1000,
                  divisions: 1000,
                  labels: RangeLabels(
                    controller.priceRange.value.start.round().toString(),
                    controller.priceRange.value.end.round().toString(),
                  ),
                ),
              );
            }),
            const SizedBox(height: 2),

            const Text(
              "Rating",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Obx(() {
              return Column(
                children:
                    [
                      {"label": "4.5 and above", "stars": 4.5},
                      {"label": "4.0 - 4.5", "stars": 4.0},
                      {"label": "3.5 - 4.0", "stars": 3.5},
                      {"label": "3.0 - 3.5", "stars": 3.0},
                      {"label": "2.5 - 3.0", "stars": 2.5},
                    ].map((r) {
                      return RadioListTile(
                        value: r['label'],
                        groupValue: controller.selectedRating.value,
                        onChanged: (val) {
                          controller.selectedRating.value = val as String;
                          print("click");
                        },
                        activeColor: AppColors.brown,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        dense: false,
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RatingBarIndicator(
                              rating: r['stars'] as double,
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 25.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              r['label'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              );
            }),
            const SizedBox(height: 16),

            const Text(
              "Condition",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
              child: Obx(() {
                final selected = controller.selectedConditions.value;
                return SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.conditions.length,
                    itemBuilder: (context, index) {
                      final item = controller.conditions[index];
                      final isSelected = selected.contains(item);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: GestureDetector(
                          onTap: () => controller.toggleCondition(item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: isSelected
                                  ? AppColors.brown
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            const Text(
              "Available For",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
              child: Obx(() {
                final selected = controller.selectedAvailableFor.value;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.availableFor.length,
                  itemBuilder: (context, index) {
                    final item = controller.availableFor[index];
                    final isSelected = selected.contains(item);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: GestureDetector(
                        onTap: () => controller.toggleAvailableFor(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            color: isSelected
                                ? AppColors.brown
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 246, 237),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(1, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: OutlinedButton(
                    onPressed: () => controller.resetFilters(),

                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      side: const BorderSide(
                        color: Color.fromRGBO(177, 116, 87, 0),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(177, 116, 87, 1),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.applyFiltersAndNavigate(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(177, 116, 87, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 25,
                    ),
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
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
