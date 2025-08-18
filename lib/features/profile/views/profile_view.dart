import 'package:booksi/features/notifications/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:booksi/features/profile/controllers/profile_controller.dart';
import 'package:booksi/features/profile/controllers/book_controllers.dart';
import 'package:booksi/common/widgets/custom_profile_card.dart';
import 'package:booksi/common/styles/colors.dart';
import 'package:booksi/features/Home/home_view.dart';
import '../../../common/widgets/custom_bottom_navigation.dart';
import 'add_book.dart';
import 'edit_user.dart';
import '../controllers/imagekit_controller.dart';
import 'edit_book.dart';
import 'package:booksi/features/orders/order_details_view.dart';

class ProfilePage extends StatelessWidget {
  final BookController bookController = Get.find<BookController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final ImageKitController imageKitController = Get.find<ImageKitController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final double cardWidth = media.size.width * 0.6;
    final double cardHeight = media.size.height * 0.36;
    final double addBtnSize = media.size.width * 0.11;
    final double horizontalPadding = media.size.width * 0.04;
    final double verticalPadding = media.size.height * 0.03;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: isDarkTheme ? Colors.black : AppColors.white,
        elevation: isDarkTheme ? 0 : 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: Text(
          'profile'.tr,
          style: TextStyle(
            color: isDarkTheme ? Colors.white : AppColors.brown,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : AppColors.brown,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: NotificationBadge(),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(media.size.width * 0.045),
                  decoration: BoxDecoration(
                    color: isDarkTheme
                        ? const Color(0xFF121212)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.teaMilk),
                    boxShadow: isDarkTheme
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.dark.withOpacity(0.04),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: media.size.width * 0.18,
                            backgroundColor: AppColors.teaMilk.withOpacity(0.5),
                            backgroundImage:
                                user?.photoUrl != null &&
                                    user!.photoUrl.isNotEmpty
                                ? NetworkImage(user.photoUrl)
                                : null,
                            child:
                                user?.photoUrl == null || user!.photoUrl.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: media.size.width * 0.18,
                                  )
                                : null,
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: InkWell(
                              onTap: () => Get.to(() => EditUser()),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.brown,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.size.height * 0.014),
                      Text(
                        user?.name ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: media.size.width * 0.052,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: media.size.width * 0.034,
                        ),
                      ),
                      if ((user?.bio ?? '').isNotEmpty) ...[
                        SizedBox(height: media.size.height * 0.008),
                        Text(
                          user!.bio,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: media.size.width * 0.034),
                        ),
                      ],
                      SizedBox(height: media.size.height * 0.014),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? Colors.white10
                                  : AppColors.teaMilk,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${'books'.tr}: ' +
                                  bookController.userBooks.length.toString(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('orders')
                                .where(
                                  'userId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid,
                                )
                                .snapshots(),
                            builder: (context, snap) {
                              final count = snap.hasData ? snap.data!.size : 0;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? Colors.white10
                                      : AppColors.teaMilk,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${'orders'.tr}: ' + count.toString(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: media.size.height * 0.016),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brown,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Get.to(() => EditUser()),
                          child: Text(
                            'edit_profile'.tr,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    final bool isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return Chip(
                      label: Text(
                        genre,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.dark,
                        ),
                      ),
                      backgroundColor: isDark
                          ? Colors.white10
                          : AppColors.teaMilk,
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
                SizedBox(
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where(
                          'userId',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(media.size.width * 0.04),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.teaMilk),
                          ),
                          child: Text(
                            'Error loading orders: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(media.size.width * 0.06),
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color(0xFF121212)
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.teaMilk),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: media.size.width * 0.14,
                                color: AppColors.teaMilk,
                              ),
                              SizedBox(height: media.size.height * 0.012),
                              Text(
                                'no_orders_yet'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: media.size.width * 0.045,
                                ),
                              ),
                              SizedBox(height: media.size.height * 0.008),
                              Text(
                                'start_exploring_buy'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: media.size.width * 0.034,
                                ),
                              ),
                              SizedBox(height: media.size.height * 0.014),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Get.off(() => HomeView()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.brown,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'browse_books'.tr,
                                    style: TextStyle(
                                      fontSize: media.size.width * 0.040,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final docs = [...snapshot.data!.docs];
                      // Sort client-side by createdAt (desc)
                      docs.sort((a, b) {
                        final aRaw = a.data()['createdAt'];
                        final bRaw = b.data()['createdAt'];
                        DateTime aTime;
                        DateTime bTime;
                        if (aRaw is Timestamp) {
                          aTime = aRaw.toDate();
                        } else if (aRaw is DateTime) {
                          aTime = aRaw;
                        } else {
                          aTime =
                              DateTime.tryParse(aRaw?.toString() ?? '') ??
                              DateTime.fromMillisecondsSinceEpoch(0);
                        }
                        if (bRaw is Timestamp) {
                          bTime = bRaw.toDate();
                        } else if (bRaw is DateTime) {
                          bTime = bRaw;
                        } else {
                          bTime =
                              DateTime.tryParse(bRaw?.toString() ?? '') ??
                              DateTime.fromMillisecondsSinceEpoch(0);
                        }
                        return bTime.compareTo(aTime);
                      });
                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data();
                          final String orderId = (data['orderId'] ?? doc.id)
                              .toString();
                          final createdAtRaw = data['createdAt'];
                          DateTime createdAt;
                          if (createdAtRaw is Timestamp) {
                            createdAt = createdAtRaw.toDate();
                          } else if (createdAtRaw is DateTime) {
                            createdAt = createdAtRaw;
                          } else {
                            createdAt =
                                DateTime.tryParse(
                                  createdAtRaw?.toString() ?? '',
                                ) ??
                                DateTime.now();
                          }

                          final List items =
                              (data['items'] as List?) ?? const [];
                          final int itemCount = items.length;
                          final payment = (data['payment'] as Map?) ?? const {};
                          final double amount = (payment['amount'] is num)
                              ? (payment['amount'] as num).toDouble()
                              : 0.0;
                          final String currency = (payment['currency'] ?? 'EGP')
                              .toString();
                          final String paymentStatus = (payment['status'] ?? '')
                              .toString();
                          final String orderStatus = (data['status'] ?? '')
                              .toString();

                          final String thumb = items.isNotEmpty
                              ? ((items.first as Map)['coverImage']
                                        ?.toString() ??
                                    '')
                              : '';
                          final String firstTitle = items.isNotEmpty
                              ? ((items.first as Map)['title']?.toString() ??
                                    '')
                              : '';
                          final int moreCount = itemCount > 1
                              ? itemCount - 1
                              : 0;
                          final String createdFmt = DateFormat(
                            'MMM d, y • h:mm a',
                          ).format(createdAt);

                          return InkWell(
                            onTap: () {
                              Get.to(() => OrderDetailsView(orderId: orderId));
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                bottom: media.size.height * 0.012,
                              ),
                              padding: EdgeInsets.all(media.size.width * 0.035),
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                    ? const Color(0xFF121212)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.teaMilk),
                                boxShadow:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: AppColors.dark.withOpacity(
                                            0.04,
                                          ),
                                          offset: const Offset(0, 2),
                                          blurRadius: 6,
                                        ),
                                      ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: media.size.width * 0.16,
                                      height: media.size.width * 0.16,
                                      color: AppColors.teaMilk.withOpacity(0.4),
                                      child: thumb.isNotEmpty
                                          ? Image.network(
                                              thumb,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.menu_book,
                                              color: AppColors.brown,
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: media.size.width * 0.035),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    firstTitle.isNotEmpty
                                                        ? firstTitle
                                                        : 'order'.tr,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          media.size.width *
                                                          0.040,
                                                    ),
                                                  ),
                                                  if (moreCount > 0)
                                                    Text(
                                                      '+$moreCount more item(s)',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize:
                                                            media.size.width *
                                                            0.032,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '$currency ${amount.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize:
                                                    media.size.width * 0.040,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.brown,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: media.size.height * 0.006,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.receipt_long,
                                              size: media.size.width * 0.040,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                '#${orderId.substring(0, orderId.length > 8 ? 8 : orderId.length)} • $createdFmt',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      media.size.width * 0.032,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: media.size.height * 0.008,
                                        ),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            _StatusChip(
                                              label: orderStatus.isEmpty
                                                  ? 'pending'.tr
                                                  : orderStatus,
                                              background: AppColors.teaMilk,
                                              textColor: AppColors.dark,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                SizedBox(height: media.size.height * 0.1),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;

  const _StatusChip({
    required this.label,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
