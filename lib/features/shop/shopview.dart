import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/widgets/custom-book-cart.dart';
import '../../common/styles/colors.dart';
import '../../common/widgets/custom_bottom_navigation.dart';
import '../filter/filter_view.dart';
import 'BooksView.dart';
import 'book_model.dart';
import 'shop_controller.dart';

class ShopView extends StatelessWidget {
  final Map<String, dynamic> filters = Get.arguments ?? {};
  final ShopController controller = Get.put(ShopController());
  final TextEditingController _searchController = TextEditingController();

  ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: false,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          bool isSearchingOrFiltering =
              controller.searchQuery.value.isNotEmpty ||
              controller.currentFilters.isNotEmpty;
          bool hasFilters = controller.filteredBooks.isNotEmpty;

          return Column(
            children: [
               SizedBox(height: 5.h),
              _buildSearchBar(context),
              Expanded(
                child: hasFilters
                    ? GridView.builder(
                        padding:  EdgeInsets.all(6.r),
                        itemCount: controller.filteredBooks.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                              childAspectRatio: 0.65,
                            ),
                        itemBuilder: (context, index) {
                          final book = controller.filteredBooks[index];
                          return BookCard(
                            id: book.id,
                            imageUrl: book.coverImage,
                            title: book.title,
                            author: book.author,
                            price: book.price.toString(),
                            index: index,
                            ownerId: book.ownerId,
                            averageRating: book.averageRating,
                            availableFor: book.availableFor,
                          );
                        },
                      )
                    : isSearchingOrFiltering
                    ? Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(fontSize: 20, color: AppColors.brown),
                        ),
                      )
                    : ListView(
                        padding:  EdgeInsets.symmetric(horizontal: 10.r),
                        children: [
                          SizedBox(height: 10.h),
                          _buildSection(
                            "best_selling".tr,
                            controller.bestSellingBooks,
                          ),
                           SizedBox(height: 10.h),
                          _buildCategoriesSection(),
                           SizedBox(height: 10.h),
                          _buildSection(
                            "new_arrivals".tr,
                            controller.newArrivalBooks,
                          ),
                         SizedBox(height: 10.h),
                          _buildSectionallbooks(
                            "all_books".tr,
                            controller.allBooks,
                          ),
                          SizedBox(height: 80.h),
                        ],
                      ),
              ),
            ],
          );
        }),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(Icons.search, color: AppColors.brown, size: 27),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                if (_searchController.text != controller.searchQuery.value) {
                  _searchController.text = controller.searchQuery.value;
                }
                return TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    controller.filterBooks(value);
                  },
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "search_books".tr,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.brown),
                  ),
                );
              }),
            ),
            IconButton(
              icon:  Icon(Icons.tune, color: AppColors.brown, size: 27.sp),
              onPressed: () async {
                final result = await Get.to(
                  () => FilterView(),
                  arguments: controller.currentFilters,
                );
                controller.applyFilters(result);
                if (result == null) {
                  controller.searchQuery.value = '';
                  _searchController.clear();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.brown, size: 27),
              onPressed: () {
                controller.applyFilters(null);
                controller.searchQuery.value = '';
                _searchController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Book> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:  TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Get.to(() => BooksView(title: title, books: books));
            //   },
            //   child: Text(
            //     'see_all'.tr,
            //     style: TextStyle(
            //       color: AppColors.brown,
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 11.h),
        SizedBox(
          height: 270.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                id: book.id,
                imageUrl: book.coverImage,
                title: book.title,
                author: book.author,
                price: book.price.toString(),
                index: index,
                ownerId: book.ownerId,
                averageRating: book.averageRating,
                availableFor: book.availableFor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionallbooks(String title, List<Book> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => BooksView(title: title, books: books));
              },
              child: Text(
                'see_all'.tr,
                style: TextStyle(
                  color: AppColors.brown,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 11.h),
        SizedBox(
          height: 270.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                id: book.id,
                imageUrl: book.coverImage,
                title: book.title,
                author: book.author,
                price: book.price.toString(),
                index: index,
                ownerId: book.ownerId,
                averageRating: book.averageRating,
                availableFor: book.availableFor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    const genreOptions = [
      'Fiction',
      'Fantasy',
      'Science Fiction',
      'Mystery & Thriller',
      'Romance',
      'Historical',
      'Young Adult',
      'Horror',
      'Biography',
      'Personal Growth',
    ];

    final categoryIcons = {
      'Fiction': Icons.menu_book,
      'Fantasy': Icons.auto_stories,
      'Science Fiction': Icons.science,
      'Mystery & Thriller': Icons.dangerous,
      'Romance': Icons.favorite,
      'Historical': Icons.history,
      'Young Adult': Icons.people,
      'Horror': Icons.nights_stay,
      'Biography': Icons.book,
      'Personal Growth': Icons.self_improvement,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.0.r),
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
         SizedBox(height: 12.h),
        SizedBox(
          height: 95.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: genreOptions.length,
            itemBuilder: (context, index) {
              final genre = genreOptions[index].toLowerCase().replaceAll(
                ' ',
                '_',
              );
              return GestureDetector(
                onTap: () {
                  final filteredBooks = controller.allBooks
                      .where(
                        (book) =>
                            book.genre.toLowerCase() ==
                            genreOptions[index].toLowerCase(),
                      )
                      .toList();

                  Get.to(
                    () => BooksView(
                      title: genreOptions[index],
                      books: filteredBooks,
                    ),
                  );
                },
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10.r),
                  child: Column(
                    children: [
                      Container(
                        padding:  EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: AppColors.teaMilk.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          categoryIcons[genreOptions[index]] ?? Icons.book,
                          color: AppColors.brown,
                          size: 35,
                        ),
                      ),
                       SizedBox(height: 4.h),
                      Text(
                        genre.tr,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                       SizedBox(height: 7.h),
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
