import 'dart:ui';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/styles/colors.dart';

class CartController extends GetxController {
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cartItems')
          .get();
      cartItems.value = snapshot.docs.map((doc) {
        return {...doc.data(), 'quantity': doc.data()['quantity'] ?? 1};
      }).toList();
    }
  }

  Future<void> addToCart({
    required String bookId,
    required String title,
    required String author,
    required String coverImage,
    required double price,
    int quantity = 1,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(
        "Error",
        "Please log in to add items to cart",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(156, 255, 255, 255),
        colorText: AppColors.black,
      );
      return;
    }

    try {
      final isBookInCart = cartItems.any((item) => item['bookId'] == bookId);

      if (isBookInCart) {
        Get.snackbar(
          "Info",
          "Book already in cart!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromARGB(156, 255, 255, 255),
          colorText: AppColors.black,
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cartItems')
          .doc(bookId)
          .set({
            'bookId': bookId,
            'title': title,
            'author': author,
            'coverImage': coverImage,
            'price': price,
            'quantity': quantity,
            'addedAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      await fetchCartItems();

      Get.snackbar(
        "Success",
        "Book added to cart successfully!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(156, 255, 255, 255),
        colorText: AppColors.black,
      );
    } catch (e) {
      print("Error adding to cart: $e");
      Get.snackbar(
        "Error",
        "Failed to add book to cart: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(156, 255, 255, 255),
        colorText: AppColors.black,
      );
    }
  }

  Future<void> updateQuantity(String bookId, int newQuantity) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cartItems')
            .doc(bookId)
            .update({'quantity': newQuantity});
        await fetchCartItems();
      } catch (e) {
        print("Error updating quantity: $e");
      }
    }
  }

  Future<void> removeFromCart(String bookId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cartItems')
            .doc(bookId)
            .delete();
        await fetchCartItems();
        Get.snackbar(
          "",
          "Book removed from cart!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromARGB(156, 255, 255, 255),
          colorText: AppColors.black,
        );
      } catch (e) {
        print("Error removing from cart: $e");
        Get.snackbar(
          "Error",
          "Failed to remove book from cart: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromARGB(156, 255, 255, 255),
          colorText: AppColors.black,
        );
      }
    }
  }


  

  int getQuantity(String bookId) {
    final item = cartItems.firstWhere(
      (item) => item['bookId'] == bookId,
      orElse: () => {'quantity': 1},
    );
    return item['quantity'] ?? 1;
  }
}
