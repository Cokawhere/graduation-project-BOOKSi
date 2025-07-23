import 'package:flutter/material.dart';

import '../styles/colors.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String price;
  final VoidCallback onAdd;
  final int index;

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.price,
    required this.onAdd,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 900,

      margin: const EdgeInsets.all(3),
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
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                width: double.infinity,
                color: AppColors.brown,
                child: const Icon(Icons.error, color: AppColors.white),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "EGP",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(width: 33),
                        ],
                      ),
                      InkWell(
                        onTap: onAdd,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.brown,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
