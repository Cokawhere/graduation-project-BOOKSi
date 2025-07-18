import 'package:cloud_firestore/cloud_firestore.dart';
import 'book_model.dart';

class ShopServices{
  static Future<List<Book>> getBooksByTag(String tag) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('approved', isEqualTo: true)
        .where('isDeleted', isEqualTo: false)
        .where('tags', arrayContains: tag) // ← field like: tags: ['best']
        .get();

    return snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList();
  }
}
