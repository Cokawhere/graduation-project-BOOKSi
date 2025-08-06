import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addToCart({
    required String bookId,
    required String title,
    required String author,
    required String coverImage,
    required double price,
    int quantity = 1,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar("Error", "Please log in to add items to cart");
        return;
      }

      final cartRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cartItems')
          .doc(bookId);

      final cartDoc = await cartRef.get();
      if (cartDoc.exists) {
        await cartRef.update({
          'quantity': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await cartRef.set({
          'bookId': bookId,
          'title': title,
          'author': author,
          'coverImage': coverImage,
          'price': price,
          'quantity': quantity,
          'addedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      Get.snackbar("Success", "Book added to cart successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to add book to cart: $e");
      print("Error adding to cart: $e");
    }
  }
}
