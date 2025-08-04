import 'package:cloud_firestore/cloud_firestore.dart';
import '../shop/book_model.dart';
import 'book_details_model.dart';

class BookDetailsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<BookDetailsModel> getBookDetailsById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('books').doc(id).get();
    if (!doc.exists) throw Exception('Book not found');

    final data = doc.data()!;
    final ownerId = data['ownerId'];

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(ownerId).get();
    final role = userDoc.data()?['role'] ?? 'user';

    return BookDetailsModel.fromMap(data, role);
  }

  static Future<List<Book>> getBooksByGenre(String genre) async {
    final querySnapshot = await _firestore
        .collection('books')
        .where('genre', isEqualTo: genre)
        .limit(10) 
        .get();
    return querySnapshot.docs
        .map((doc) => Book.fromMap(doc.data()))
        .toList();
  }
}

