// 📁 book_details_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booksi/common/styles/colors.dart';
import '../../common/widgets/custom-book-cart.dart';
import '../shop/book_model.dart';
import 'book_details_conroller.dart';

class BookDetailsView extends StatelessWidget {
  final String bookId;
  const BookDetailsView({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookDetailsController(bookId));

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 350,
                    color: AppColors.brown,
                    child: Stack(
                      children: [
                        Obx(() {
                          final imageList =
                              controller.book.value!.images.isEmpty
                              ? List<String>.filled(
                                  4,
                                  controller.book.value!.coverImage,
                                )
                              : controller.book.value!.images;
                          return Image.network(
                            imageList[controller.selectedImageIndex.value],
                            height: 350,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(height: 350, color: AppColors.white),
                          );
                        }),
                        Positioned(
                          bottom: 12,
                          left: 60,
                          right: 60,
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              height: 70,
                              child: Obx(() {
                                final imageList =
                                    controller.book.value!.images.isEmpty
                                    ? List<String>.filled(
                                        4,
                                        controller.book.value!.coverImage,
                                      )
                                    : controller.book.value!.images;
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () =>
                                          controller.changeImage(index),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                controller
                                                        .selectedImageIndex
                                                        .value ==
                                                    index
                                                ? AppColors.brown
                                                : Colors.transparent,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            imageList[index],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      controller.book.value!.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'by ${controller.book.value!.author}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: const Color.fromARGB(198, 177, 116, 87),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EGP ${controller.book.value!.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),

                        if (controller.isLibraryOwner())
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.orange,
                                size: 30,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                controller.book.value!.averageRating
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),
                  if (controller.book.value!.availableFor.contains('swap'))
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        controller
                                            .ownerPhotoUrl
                                            .value
                                            .isNotEmpty
                                        ? NetworkImage(
                                            controller.ownerPhotoUrl.value,
                                          )
                                        : null,
                                    child:
                                        controller.ownerPhotoUrl.value.isEmpty
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    controller.ownerName.value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  210,
                                  151,
                                  125,
                                ),
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 15,
                                ),
                              ),
                              child: const Text(
                                'Chat with Owner',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      controller.isDescriptionExpanded.value
                          ? controller.book.value!.description
                          : controller.book.value!.description.length > 150
                          ? '${controller.book.value!.description.substring(0, 150)}...'
                          : controller.book.value!.description,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  if (controller.book.value!.description.length > 150)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextButton(
                        onPressed: controller.toggleDescription,
                        child: Text(
                          controller.isDescriptionExpanded.value
                              ? 'Show less'
                              : 'Read more',
                          style: TextStyle(
                            color: AppColors.brown,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 1),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Wrap(
                          spacing: 8,
                          children: controller.book.value!.availableFor
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: AppColors.brown,
                                  labelStyle: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const VerticalDivider(
                        color: AppColors.brown,
                        thickness: 4,
                        width: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Chip(
                          label: Text(controller.book.value!.genre),
                          backgroundColor: AppColors.brown,
                          labelStyle: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text('Condition :  ', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 5),
                        Text(
                          controller.book.value!.condition,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3),

                  if (!controller.isLibraryOwner())
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text('Location  :', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 16),
                          Text(
                            controller.book.value!.location,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 5),

                  _buildSection(
                    "You might also like",
                    controller.youAlsoMayLike,
                  ),

                  SizedBox(height: 300),
                ],
              ),
            ),

            Positioned(
              top: 40,
              left: 12,
              child: SafeArea(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                      size: 30,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 12,
              child: SafeArea(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: AppColors.black,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.white,
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
                    color: AppColors.background,
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
                    onPressed: () {}, // Add to cart logic
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
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {}, // Buy now logic
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 25,
                    ),
                  ),
                  child: const Text(
                    "Buy Now",
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

  Widget _buildSection(String title, List<Book> books) {
    if (books.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return GestureDetector(
                  onTap: () {
                    print(book.title);
                    Get.to(() => BookDetailsView(bookId: book.id));
                  },
                  child: BookCard(
                    id: book.id,
                    imageUrl: book.coverImage,
                    title: book.title,
                    author: book.author,
                    price: book.price.toString(),
                    index: index,
                    ownerId: book.ownerId,
                    averageRating: book.averageRating,
                    availableFor: book.availableFor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
