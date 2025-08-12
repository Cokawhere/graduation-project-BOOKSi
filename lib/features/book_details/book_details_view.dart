import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booksi/common/styles/colors.dart';
import '../../common/widgets/custom-book-cart.dart';
import '../Home/home_view.dart';
import '../cart/cart_controller.dart';
import '../shipping information/shipping-information_controller.dart';
import '../shipping information/shipping-information_view.dart';
import '../shop/book_model.dart';
import 'book_details_conroller.dart';
import 'package:intl/intl.dart';

import 'review_model.dart';

class BookDetailsView extends StatefulWidget {
  final String? bookId;
  const BookDetailsView({super.key, this.bookId});

  @override
  State<BookDetailsView> createState() => _BookDetailsViewState();
}

class _BookDetailsViewState extends State<BookDetailsView> {
  late final BookDetailsController controller;
  final CartController cartController = Get.find<CartController>();
  bool hasPurchasedBook = false;

  @override
  void initState() {
    super.initState();
    final bookId = Get.arguments?['bookId'] ?? widget.bookId;
    if (bookId == null || bookId.isEmpty) {
      print("Error: No valid bookId provided");
      Get.snackbar("Error", "Invalid book ID");
      return;
    }
    print(" Initializing BookDetailsView with bookId: $bookId");
    controller = Get.put(BookDetailsController(bookId), tag: bookId);

    controller.checkIfUserPurchasedBook().then((value) {
      setState(() {
        hasPurchasedBook = value;
      });
    });
  }

  @override
  void dispose() {
    Get.delete<BookDetailsController>(tag: widget.bookId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 50,

        centerTitle: true,
        title: Text(
          'book_details'.tr,

          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.brown,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brown, size: 30),
          onPressed: () => Get.off(HomeView()),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          final isOwner =
              currentUserId != null &&
              currentUserId == controller.book.value?.ownerId;
          ;
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  child: Stack(
                    children: [
                      Obx(() {
                        final imageList = controller.book.value!.images.isEmpty
                            ? List<String>.filled(
                                4,
                                controller.book.value!.coverImage,
                              )
                            : controller.book.value!.images;
                        return Image.network(
                          imageList[controller.selectedImageIndex.value],
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 300, color: AppColors.white),
                        );
                      }),
                      Positioned(
                        bottom: 12,
                        left: 100,
                        right: 100,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            height: 40,
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
                                    onTap: () => controller.changeImage(index),
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imageList[index],
                                          width: 40,
                                          height: 40,
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
                                      controller.ownerPhotoUrl.value.isNotEmpty
                                      ? NetworkImage(
                                          controller.ownerPhotoUrl.value,
                                        )
                                      : null,
                                  child: controller.ownerPhotoUrl.value.isEmpty
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
                            onPressed: isOwner
                                ? null
                                : () {
                                    Get.snackbar('info'.tr, 'add_chat'.tr);
                                  },
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
                            child: Text(
                              'chat_with_owner'.tr,
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

                const SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'description'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
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
                            ? 'show_less'.tr
                            : 'read_more'.tr,
                        style: TextStyle(color: AppColors.brown, fontSize: 18),
                      ),
                    ),
                  ),
                SizedBox(height: 10),
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
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  210,
                                  151,
                                  125,
                                ),
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
                      color: Color.fromARGB(255, 210, 151, 125),
                      thickness: 4,
                      width: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Chip(
                        label: Text(controller.book.value!.genre),
                        backgroundColor: const Color.fromARGB(
                          255,
                          210,
                          151,
                          125,
                        ),
                        labelStyle: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!controller.isLibraryOwner())
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          leading: const Icon(
                            Icons.location_on,
                            color: AppColors.brown,
                          ),
                          title: Text(
                            'location'.tr,
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: Text(
                            controller.book.value!.location,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 180),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        leading: const Icon(
                          Icons.info_outline,
                          color: AppColors.brown,
                        ),
                        title: Text(
                          'condition'.tr,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Text(
                          controller.book.value!.condition,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 180),
                  ],
                ),

                _buildSection(
                  'you_might_also_like'.tr,
                  controller.youAlsoMayLike,
                ),

                if (controller.book.value!.ownerRole == 'library')
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'reviews'.tr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.brown,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.checkPurchaseAndShowReviewDialog(
                                  context,
                                  controller.bookId,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brown,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ),
                              ),
                              child: Text(
                                'add_review'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...controller.reviews.map(
                          (review) => _buildReviewCard(review),
                        ),
                        SizedBox(height: 10),
                        Center(),
                      ],
                    ),
                  ),

                SizedBox(height: 100),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        final availableFor = controller.book.value?.availableFor ?? [];
        final isSwapOnly =
            availableFor.contains('swap') && !availableFor.contains('sell');
        final isSellOrBoth =
            availableFor.contains('sell') ||
            (availableFor.contains('swap') && availableFor.contains('sell'));

        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        final isOwner =
            currentUserId != null &&
            currentUserId == controller.book.value?.ownerId;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color.fromARGB(0, 255, 255, 255),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: isSwapOnly
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isOwner
                              ? null
                              : () {
                                  Get.snackbar("add chatttttttt", "");
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brown,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 40,
                            ),
                          ),
                          child: Text(
                            'chat_with_owner'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 60,
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: OutlinedButton(
                            onPressed: isOwner
                                ? null
                                : () {
                                    final cartController =
                                        Get.find<CartController>();
                                    cartController.addToCart(
                                      bookId: controller.book.value!.id,
                                      title: controller.book.value!.title,
                                      author: controller.book.value!.author,
                                      coverImage:
                                          controller.book.value!.coverImage,
                                      price: controller.book.value!.price,
                                    );
                                  },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              fixedSize: Size(20, 20),
                              side: const BorderSide(
                                color: Color.fromRGBO(177, 116, 87, 0),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Icon(
                              Icons.shopping_cart,
                              color: AppColors.brown,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 60,
                        width: 240,
                        child: ElevatedButton(
                          onPressed: isOwner
                              ? null
                              : () async {
                                  final cartController =
                                      Get.find<CartController>();

                                  for (var item in cartController.cartItems) {
                                    await cartController.removeFromCart(
                                      item['bookId'],
                                    );
                                  }

                                  cartController.addToCart(
                                    bookId: controller.book.value!.id,
                                    title: controller.book.value!.title,
                                    author: controller.book.value!.author,
                                    coverImage:
                                        controller.book.value!.coverImage,
                                    price: controller.book.value!.price,
                                    quantity: 1,
                                  );

                                  Get.put(ShippingInfoController());
                                  Get.to(() => ShippingInfoView());
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              177,
                              116,
                              87,
                              1,
                            ),

                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'buy_now'.tr,
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
        );
      }),
    );
  }

  Widget _buildSection(String title, List<Book> books) {
    if (books.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    Get.toNamed(
                      '/book-details',
                      arguments: {'bookId': book.id},
                    );
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

  Widget _buildReviewCard(Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                controller.getUserPhotoUrl(review.reviewerId).isNotEmpty
                ? NetworkImage(controller.getUserPhotoUrl(review.reviewerId))
                : null,
            child: controller.getUserPhotoUrl(review.reviewerId).isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      controller.getUserName(review.reviewerId),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(review.comment, style: TextStyle(fontSize: 16)),
                Text(
                  ' ${DateFormat('MMM dd, yyyy').format(review.createdAt.toDate())}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
