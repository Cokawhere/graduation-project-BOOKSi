import 'package:booksi/features/profile/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final uid = currentUserId;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

  // Create book
  Future<void> createBook(Book book) async {
    await _firestore.collection('books').doc(book.id).set(book.toMap());
  }

  // Get book by ID
  Future<Book?> getBookById(String bookId) async {
    final doc = await _firestore.collection('books').doc(bookId).get();
    if (doc.exists) {
      return Book.fromMap(doc.data()!);
    }
    return null;
  }

  // Update book
  Future<void> updateBook(Book book) async {
    await _firestore.collection('books').doc(book.id).update(book.toMap());
  }

  // Delete book
  Future<void> deleteBook(String bookId) async {
    await _firestore.collection('books').doc(bookId).delete();
  }

  // Stream books by user (ownerId = current user)
  Stream<List<Book>> streamBooksByCurrentUser() {
    final uid = currentUserId;
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('books')
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map(
          (query) => query.docs.map((doc) => Book.fromMap(doc.data())).toList(),
        );
  }

  // Stream books by user ID
  Stream<List<Book>> streamBooksByUser(String userId) {
    return _firestore
        .collection('books')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map(
          (query) => query.docs.map((doc) => Book.fromMap(doc.data())).toList(),
        );
  }

  // Stream all books
  Stream<List<Book>> streamAllBooks() {
    return _firestore
        .collection('books')
        .snapshots()
        .map(
          (query) => query.docs.map((doc) => Book.fromMap(doc.data())).toList(),
        );
  }
}

class ImageKitService {
  final String uploadUrl = 'https://upload.imagekit.io/api/v1/files/upload';
  final String publicKey = 'public_MaCFmiSUHRma6JalHM2Ux4ECbMw=';
  final String privateKey = 'private_QmWggbSNu+9ZAq8j/iYQHtu0k0g=';
  final String folder = '/books';

  Future<Map<String, dynamic>?> uploadImage(File imageFile) async {
    final base64Image = base64Encode(await imageFile.readAsBytes());
    final fileName = basename(imageFile.path);

    final response = await http.post(
      Uri.parse(uploadUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$privateKey:'))}',
      },
      body: {
        'file': 'data:image/jpeg;base64,$base64Image',
        'fileName': fileName,
        'folder': folder,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'url': data['url'], 'fileId': data['fileId']};
    } else {
      print("ImageKit upload failed: ${response.body}");
      return null;
    }
  }

  Future<void> deleteImage(String fileId) async {
    final deleteUrl = 'https://api.imagekit.io/v1/files/$fileId';

    final response = await http.delete(
      Uri.parse(deleteUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$privateKey:'))}',
      },
    );

    if (response.statusCode == 204) {
      print("Image deleted from ImageKit");
    } else {
      print("Failed to delete image: ${response.body}");
    }
  }
}
