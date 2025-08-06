import 'package:get/get.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';

class BookController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final ImageKitService _imageKitService = ImageKitService();

  final RxList<Book> userBooks = <Book>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserBooks();
  }

  void loadUserBooks() {
    final uid = _firebaseService.currentUserId;
    if (uid == null) return;
    isLoading.value = true;

    _firebaseService.streamBooksByUser(uid).listen((books) {
      userBooks.assignAll(books);
      isLoading.value = false;
    });
  }

  Future<void> addBook(Book book) async {
    await _firebaseService.createBook(book);
  }

  Future<void> updateBook(Book updatedBook) async {
    await _firebaseService.updateBook(updatedBook);
  }

  Future<void> deleteBook(String bookId) async {
    await _firebaseService.deleteBook(bookId);
  }



  
}
