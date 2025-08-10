import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booksi/features/profile/controllers/profile_controller.dart';
import 'package:booksi/features/profile/controllers/book_controllers.dart';
import 'package:booksi/common/widgets/custom_profile_card.dart';
import 'package:booksi/common/styles/colors.dart';
import '../../../common/widgets/custom_bottom_navigation.dart';
import 'add_book.dart';
import 'edit_user.dart';
import '../controllers/imagekit_controller.dart';
import 'edit_book.dart';

class ProfilePage extends StatelessWidget {
  final BookController bookController = Get.find<BookController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final ImageKitController imageKitController = Get.find<ImageKitController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double cardWidth = media.size.width * 0.6;
    final double cardHeight = media.size.height * 0.36;
    final double addBtnSize = media.size.width * 0.11;
    final double horizontalPadding = media.size.width * 0.04;
    final double verticalPadding = media.size.height * 0.03;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = profileController.user.value;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Info
              CircleAvatar(
                radius: media.size.width * 0.11,
                backgroundImage:
                    user?.photoUrl != null && user!.photoUrl.isNotEmpty
                    ? NetworkImage(user.photoUrl)
                    : null,
                child: user?.photoUrl == null || user!.photoUrl.isEmpty
                    ? Icon(Icons.person, size: media.size.width * 0.11)
                    : null,
              ),
              SizedBox(height: media.size.height * 0.015),
              Text(
                user?.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: media.size.width * 0.05,
                ),
              ),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: media.size.width * 0.035,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: media.size.height * 0.01,
                ),
                child: Text(user?.bio ?? '', textAlign: TextAlign.center),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brown,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.to(() => EditUser());
                },
                child: Text('edit_profile'.tr, style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: media.size.height * 0.03),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'your_books_for_sale_trade'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: media.size.width * 0.045,
                    ),
                  ),
                  SizedBox(
                    width: addBtnSize,
                    height: addBtnSize,
                    child: Material(
                      color: AppColors.brown,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Get.to(() => const AddBookView());
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: addBtnSize * 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: media.size.height * 0.01),
              SizedBox(
                height: cardHeight + 20,
                child: Obx(() {
                  final books = bookController.userBooks;
                  if (books.isEmpty) {
                    return Center(child: Text('no_books_added'.tr));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return BookProfileCard(
                        imageUrl: book.coverImage,
                        title: book.title,
                        author: book.author,
                        price: book.price?.toStringAsFixed(2) ?? '0.00',
                        status: book.approval ?? 'Active',
                        width: cardWidth,
                        height: cardHeight,
                        onEdit: () {
                          Get.to(() => EditBookView(book: book));
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Book'),
                              content: Text(
                                'Are you sure you want to delete this book?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            // Delete book and its image
                            final imageKitController =
                                Get.find<ImageKitController>();
                            await imageKitController.deleteBookWithImage(
                              book.id,
                              book.imageFileId,
                            );
                            Get.snackbar('Success', 'Book deleted');
                          }
                        },
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: media.size.height * 0.03),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'favorite_genres'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: media.size.width * 0.045,
                  ),
                ),
              ),
              SizedBox(height: media.size.height * 0.01),
              Wrap(
                spacing: 8,
                children: (user?.genres ?? []).map<Widget>((genre) {
                  return Chip(
                    label: Text(genre),
                    backgroundColor: AppColors.teaMilk,
                  );
                }).toList(),
              ),
              SizedBox(height: media.size.height * 0.03),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'transaction_history'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: media.size.width * 0.045,
                  ),
                ),
              ),
              SizedBox(height: media.size.height * 0.01),
              Container(
                width: double.infinity,
                height: media.size.height * 0.13,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.teaMilk),
                ),
                child: Center(
                  child: Text('transaction_history_coming_soon'.tr),
                ),
              ),
              SizedBox(height: media.size.height * 0.1),
            ],
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
