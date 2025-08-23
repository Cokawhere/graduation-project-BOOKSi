import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../features/book_details/book_details_view.dart';
import '../styles/colors.dart';

class BookCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String author;
  final String price;
  final int index;
  final String ownerId;
  final List<String> availableFor;
  final double averageRating;

  const BookCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.price,
    required this.index,
    required this.ownerId,
    required this.averageRating,
    required this.availableFor,
  });

  Future<bool> _checkLibraryRole(String ownerId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(ownerId)
          .get();
      return doc.data()?['role'] == 'library';
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatPrice(String price) {
      String cleanPrice = price.split(".").first;
      if (cleanPrice.length > 4) {
        return '${cleanPrice.substring(0, 4)}+';
      }
      return cleanPrice;
    }

    return Container(
      width: 180.w,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,

        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => BookDetailsView(bookId: id));
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      width: double.infinity,
                      color: AppColors.brown,
                      child: const Icon(Icons.error, color: AppColors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => BookDetailsView(bookId: id));
                        },
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => BookDetailsView(bookId: id));
                        },
                        child: Text(
                          author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.brown,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            availableFor.contains('sell')
                                ? Row(
                                    children: [
                                      const Text(
                                        "EGP ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      Text(
                                        formatPrice(price),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            FutureBuilder<bool>(
                              future: _checkLibraryRole(ownerId),
                              builder: (context, snapshot) {
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return SizedBox.shrink();
                                }
                                return snapshot.data!
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: AppColors.orange,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            averageRating.toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.brown,
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 7),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color:
                    availableFor.contains('Sell') &&
                        availableFor.contains('Swap')
                    ? AppColors.brown
                    : availableFor.contains('Sell')
                    ? AppColors.orange
                    : AppColors.teaMilk,
                shape: BoxShape.circle,
              ),
              child: Text(
                availableFor.contains('sell') && availableFor.contains('swap')
                    ? 'S&S'
                    : availableFor.contains('sell')
                    ? 'Sell'
                    : 'Swap',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
