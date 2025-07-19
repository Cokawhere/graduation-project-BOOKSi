import 'package:cloud_firestore/cloud_firestore.dart';
import 'book_model.dart';

class ShopServices {
  static Future<List<Book>> getAllApprovedBooks() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        .get();
        print("All Books Count: ${snapshot.docs.length}");

        

    return snapshot.docs.map((doc) {
      try {
        return Book.fromMap(doc.data());
      } catch (e) {
        print(" Error parsing book: $e");
        print("Data: ${doc.data()}");
        return null;
      }
    }).whereType<Book>().toList();
  }

  static Future<List<Book>> getNewArrivalBooks() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();
        print("All Books Count: ${snapshot.docs.length}");


    return snapshot.docs.map((doc) {
      try {
        return Book.fromMap(doc.data());
      } catch (e) {
        print(" Error parsing book: $e");
        return null;
      }
    }).whereType<Book>().toList();
  }

  static Future<List<Book>> getBestSellingBooks() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        .orderBy('totalRatings', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) {
      try {
        return Book.fromMap(doc.data());
      } catch (e) {
        print(" Error parsing book: $e");
        return null;
      }
    }).whereType<Book>().toList();
  }

 
}
