import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:booksi/common/styles/colors.dart';

class BookCard extends StatelessWidget {
  final String imageBase64;
  final String title;
  final String author;
  final String price;
  final VoidCallback onAdd;
  final int index;

  const BookCard({
    super.key,
    required this.imageBase64,
    required this.title,
    required this.author,
    required this.price,
    required this.onAdd,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 230,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 240, 236),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child:
                  imageBase64.startsWith('data:image') ||
                      imageBase64.length > 100
                  ? Image.memory(
                      base64Decode(imageBase64),
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 160,
                        width: double.infinity,
                        color: AppColors.brown,
                        child: const Icon(Icons.error, color: AppColors.white),
                      ),
                    )
                  : Container(
                      height: 140,
                      width: double.infinity,
                      color: AppColors.brown,
                      child: const Icon(Icons.book, color: AppColors.white),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    author,
                    style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("EGP", style: const TextStyle(fontSize: 13)),
                      SizedBox(width: 3),
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: onAdd,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.brown,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
