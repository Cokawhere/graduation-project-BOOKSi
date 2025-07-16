import 'package:flutter/material.dart';
import 'package:booksi/common/widgets/custom-book-cart.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../common/styles/colors.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 20),
        _buildSection("best_selling".tr),
        const SizedBox(height: 20),
        _buildCategoriesSection(),
        const SizedBox(height: 20),
        _buildSection("trending_books".tr),
        const SizedBox(height: 20),
        _buildSection("new_arrivals".tr),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: "search_books".tr,
              prefixIcon: const Icon(Icons.search, size: 30),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),

        IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'icon': Icons.menu_book, 'label': 'novels'.tr},
      {'icon': Icons.self_improvement, 'label': 'self_development'.tr},
      {'icon': Icons.nights_stay, 'label': 'literature'.tr},
      {'icon': Icons.science, 'label': 'science'.tr},
      {'icon': Icons.history, 'label': 'history'.tr},
      {'icon': Icons.auto_stories, 'label': 'religion'.tr},
      {'icon': Icons.business_center, 'label': 'business'.tr},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "book_categories".tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("see_all".tr, style: TextStyle(color: AppColors.brown)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.teaMilk.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: Text('see_all'.tr)),
          ],
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => BookCard(
              index: index,
              imageBase64: '',
              title: 'The Psychology of Money',
              author: 'Morgan Housel',
              price: '19.99',
              onAdd: () {
                print("Add to cart");
              },
            ),
          ),
        ),
      ],
    );
  }
}
