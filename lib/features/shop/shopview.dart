import 'package:flutter/material.dart';
import 'package:booksi/common/widgets/custom-book-cart.dart';
import 'package:get/get_utils/get_utils.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 24),
        _buildSection("best_selling".tr),
        const SizedBox(height: 24),
        _buildSection("trending_books".tr),
        const SizedBox(height: 24),
        _buildSection("new_arrivals".tr),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "search_books".tr,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
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
