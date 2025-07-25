import 'package:cloud_firestore/cloud_firestore.dart';
import 'book_model.dart';

class ShopServices {
  static Stream<List<Book>> getAllApprovedBooksStream() {
    return FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              try {
                return Book.fromMap(doc.data());
              } catch (e) {
                print("Error parsing book: $e");
                return null;
              }
            }).whereType<Book>().toList());
  }

  static Stream<List<Book>> getBestSellingBooksStream() {
    return FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        .orderBy('totalRatings', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              try {
                return Book.fromMap(doc.data());
              } catch (e) {
                print("Error parsing best seller: $e");
                return null;
              }
            }).whereType<Book>().toList());
  }

  static Stream<List<Book>> getNewArrivalBooksStream() {
    return FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              try {
                return Book.fromMap(doc.data());
              } catch (e) {
                print("Error parsing new arrival: $e");
                return null;
              }
            }).whereType<Book>().toList());
  }
  
}
