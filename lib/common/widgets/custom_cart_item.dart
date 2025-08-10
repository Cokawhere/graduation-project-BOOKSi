import 'package:booksi/common/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/cart/cart_controller.dart';

class CustomCartItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final CartController cartController = Get.find<CartController>();

  CustomCartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          elevation: 4,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['coverImage'],
                    width: 70,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey,
                        child: const Icon(Icons.error, color: Colors.white),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'].length > 19
                          ? '${item['title'].substring(0, 18)}...'
                          : item['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'by ${item['author']} ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(176, 62, 61, 61),
                      ),
                    ),

                    Text(
                      'EGP ${item['price']}',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Positioned(
          right: 20,
          top: 50,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: const Color.fromARGB(0, 121, 85, 72),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (item['quantity'] > 1) {
                      cartController.updateQuantity(
                        item['bookId'],
                        item['quantity'] - 1,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.black,
                      size: 19,
                    ),
                  ),
                ),

                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${cartController.getQuantity(item['bookId'])}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    cartController.updateQuantity(
                      item['bookId'],
                      item['quantity'] + 1,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.brown,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 19),
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: 0,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.close, color: AppColors.black, size: 20),
            onPressed: () => cartController.removeFromCart(item['bookId']),
          ),
        ),
      ],
    );
  }
}
