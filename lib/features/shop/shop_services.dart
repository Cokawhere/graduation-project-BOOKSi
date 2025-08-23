import 'package:cloud_firestore/cloud_firestore.dart';
import 'book_model.dart';

class ShopServices {
  static Stream<List<Book>> getAllApprovedBooksStream() {
    return FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        // .where('quantity', isGreaterThanOrEqualTo: 1) 
        .snapshots()
        .map((snapshot) {
          print("Total documents fetched: ${snapshot.docs.length}");
          snapshot.docs.forEach((doc) {
            print("Document data: ${doc.data()}");
          });
          return snapshot.docs
              .map((doc) {
                try {
                  return Book.fromMap(doc.data());
                } catch (e) {
                  print("Error parsing book: $e, Data: ${doc.data()}");
                  return null;
                }
              })
              .whereType<Book>()
              .where((book) => book.quantity >= 1)
              .toList();
        });
  }

  static Stream<List<Book>> getBestSellingBooksStream() {
    return FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        // .where('quantity', isGreaterThanOrEqualTo: 1) 
        .orderBy('totalRatings', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          print("Best selling documents fetched: ${snapshot.docs.length}");
          snapshot.docs.forEach((doc) {
            print("Best selling document data: ${doc.data()}");
          });
          return snapshot.docs
              .map((doc) {
                try {
                  return Book.fromMap(doc.data());
                } catch (e) {
                  print("Error parsing best seller: $e, Data: ${doc.data()}");
                  return null;
                }
              })
              .whereType<Book>()
              .where((book) => book.quantity >= 1) 
              .toList();
        });
  }

  static Stream<List<Book>> getNewArrivalBooksStream() {
    return FirebaseFirestore.instance
        .collection('books')
        .where('approval', isEqualTo: 'approved')
        .where('isDeleted', isEqualTo: false)
        // .where('quantity', isGreaterThanOrEqualTo: 1) 
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          print("New arrival documents fetched: ${snapshot.docs.length}");
          snapshot.docs.forEach((doc) {
            print("New arrival document data: ${doc.data()}");
          });
          return snapshot.docs
              .map((doc) {
                try {
                  return Book.fromMap(doc.data());
                } catch (e) {
                  print("Error parsing new arrival: $e, Data: ${doc.data()}");
                  return null;
                }
              })
              .whereType<Book>()
              .where((book) => book.quantity >= 1) 
              .toList();
        });
  }
}
