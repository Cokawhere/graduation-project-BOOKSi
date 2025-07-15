import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:booksi/common/styles/colors.dart';
import 'package:booksi/common/widgets/custom-book-cart.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 24),
        _buildSection("Best Selling"),
        const SizedBox(height: 24),
        _buildSection("Trending in Books"),
        const SizedBox(height: 24),
        _buildSection("New Arrivals"),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search books...",
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
            TextButton(onPressed: () {}, child: const Text("See All")),
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
