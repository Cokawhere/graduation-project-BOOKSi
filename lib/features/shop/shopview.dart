import 'package:flutter/material.dart';
import 'package:booksi/common/widgets/custom-book-cart.dart';
import 'package:get/get.dart';
import '../../common/styles/colors.dart';
import 'package:booksi/features/shop/shop_controller.dart';

import 'BooksView.dart';
import 'book_model.dart';

class ShopView extends StatelessWidget {
  final ShopController controller = Get.put(ShopController());

  ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        children: [
          const SizedBox(height: 10),
          _buildSearchBar(),
          _buildSection("best_selling".tr, controller.bestSellingBooks),
          const SizedBox(height: 20),
          _buildCategoriesSection(),
          const SizedBox(height: 20),
          _buildSection("trending_books".tr, controller.trendingBooks),
          const SizedBox(height: 20),
          _buildSection("new_arrivals".tr, controller.newArrivalBooks),
        ],
      );
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.search, size: 28, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: controller.filterBooks,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: "search_books".tr,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Book> books) {
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
            GestureDetector(
              onTap: () {
                Get.to(() => BooksView(title: title, books: books));
              },
              child: Text(
                'see_all'.tr,
                style: TextStyle(color: AppColors.brown),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                index: index,
                imageUrl: book.coverImage,
                title: book.title,
                author: book.author,
                price: book.price?.toString() ?? '0',
                onAdd: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'icon': Icons.menu_book, 'label': 'novels'.tr, 'genre': 'novels'},
      {
        'icon': Icons.self_improvement,
        'label': 'self_development'.tr,
        'genre': 'self_development',
      },
      {
        'icon': Icons.nights_stay,
        'label': 'literature'.tr,
        'genre': 'literature',
      },
      {'icon': Icons.science, 'label': 'science'.tr, 'genre': 'science'},
      {'icon': Icons.history, 'label': 'history'.tr, 'genre': 'history'},
      {'icon': Icons.auto_stories, 'label': 'religion'.tr, 'genre': 'religion'},
      {
        'icon': Icons.business_center,
        'label': 'business'.tr,
        'genre': 'business',
      },
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
              return GestureDetector(
                onTap: () {
                  final genre = item['genre'];
                  final filteredBooks = controller.allBooks
                      .where(
                        (book) =>
                            book.genre.toLowerCase() ==
                            genre.toString().toLowerCase(),
                      )
                      .toList();

                  Get.to(
                    () => BooksView(
                      title: item['label'] as String,
                      books: filteredBooks,
                    ),
                  );
                },
                child: Padding(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
