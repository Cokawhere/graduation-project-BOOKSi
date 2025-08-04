import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../shop/book_model.dart';
import 'book_details_model.dart';
import 'book_details_services.dart';

class BookDetailsController extends GetxController {
 final String bookId;

  BookDetailsController(this.bookId);

  var isLoading = true.obs;
  var book = Rxn<BookDetailsModel>();
  var selectedImageIndex = 0.obs;
  var isDescriptionExpanded = false.obs;
  var images = <String>[].obs;
  var ownerName = ''.obs;
  var ownerPhotoUrl = ''.obs;
  var youAlsoMayLike = <Book>[].obs;


    @override
  void onInit() {
    super.onInit();
    fetchBookDetails();
  }


  


 void fetchBookDetails() async {
  if (bookId.isEmpty) {
    print("Error: bookId is empty");
    Get.snackbar("Error", "Invalid book ID");
    isLoading.value = false;
    return;
  }
  isLoading.value = true;
  try {
    final bookData = await BookDetailsService.getBookDetailsById(bookId);
    print("Fetched book data: ${bookData.title}, ID: ${bookData.id}");
    book.value = bookData;

    if (bookData.images.isEmpty) {
      images.value = List.generate(4, (_) => bookData.coverImage);
    } else {
      images.value = bookData.images;
    }

    if (bookData.ownerId.isNotEmpty) {
      await fetchOwnerData(bookData.ownerId);
    }

    await fetchSimilarBooks(bookData.genre);
  } catch (e) {
    print("Error fetching book details: $e");
    Get.snackbar("Error", "Failed to load book details: $e");
  } finally {
    isLoading.value = false;
  }
}

  Future<void> fetchOwnerData(String ownerId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(ownerId)
          .get();
      if (doc.exists) {
        final data = doc.data();
        ownerName.value = data?['name'] ?? 'Unknown';
        ownerPhotoUrl.value = data?['photoUrl'] ?? '';
      }
    } catch (e) {
      print('Error fetching owner data: $e');
    }
  }

  Future<void> fetchSimilarBooks(String genre) async {
    try {
      final books = await BookDetailsService.getBooksByGenre(genre);
      youAlsoMayLike.value = books.where((book) => book.id != bookId).toList();
    } catch (e) {
      print('Error fetching similar books: $e');
    }
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  void changeImage(int index) {
    selectedImageIndex.value = index;
  }

  bool isBookForSwapOnly() {
    final available = book.value?.availableFor ?? [];
    return available.contains('Swap') && !available.contains('Sell');
  }

  bool isLibraryOwner() {
    return book.value?.ownerRole == 'library';
  }
}
