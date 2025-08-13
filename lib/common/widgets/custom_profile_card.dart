import 'package:flutter/material.dart';
import 'package:booksi/common/styles/colors.dart';

class BookProfileCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String price;
  final String status;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final double? width;
  final double? height;

  const BookProfileCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.price,
    this.status = 'Active',
    this.onEdit,
    this.onDelete,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    String formatPrice(String price) {
      String cleanPrice = price.split(".").first;
      if (cleanPrice.length > 4) {
        return '${cleanPrice.substring(0, 4)}+';
      }
      return cleanPrice;
    }

    return SizedBox(
      width: width ?? 150,
      height: height ?? 240,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                height: (height ?? 240) * 0.5,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: (height ?? 240) * 0.5,
                  width: double.infinity,
                  color: AppColors.brown,
                  child: const Icon(Icons.error, color: AppColors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'EGP ${formatPrice(price)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFFD18B5B),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFE7F8ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Color(0xFF3CB371),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                      color: AppColors.brown,
                    ),
                    onPressed: onEdit,
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: onDelete,
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
