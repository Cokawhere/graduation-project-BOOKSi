import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../shop/book_model.dart';
import 'book_details_model.dart';
import 'book_details_services.dart';
import 'review_model.dart';

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
  var reviews = <Review>[].obs;
  final Map<String, Map<String, dynamic>> _userCache = {};

  @override
  void onInit() {
    super.onInit();
    fetchBookDetails();
  }

  void fetchBookDetails() async {
    if (bookId.isEmpty) {
      Get.snackbar("Error", "Invalid book ID");
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    try {
      final bookData = await BookDetailsService.getBookDetailsById(bookId);
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
      await fetchReviews();
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to load book details: $e");
    } finally {
      isLoading.value = false;
      print("Loading complete");
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
      youAlsoMayLike.value = books
          .where((book) => book.id != bookId && !book.isDeleted)
          .toList();
    } catch (e) {
      print('Error fetching similar books: $e');
    }
  }

  Future<void> fetchReviews() async {
    try {
      print("🔍 Starting fetchReviews for bookId: $bookId");
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('targetId', isEqualTo: bookId)
          .get();
      print("🔍 QuerySnapshot docs count: ${querySnapshot.docs.length}");
      final reviewDocs = querySnapshot.docs;
      final reviewerIds = reviewDocs
          .map((doc) => Review.fromMap(doc.data()).reviewerId)
          .toSet();
      await _fetchUsersData(reviewerIds);
      final fetchedReviews = reviewDocs.map((doc) {
        print("🔍 Review raw data: ${doc.data()}");
        final review = Review.fromMap(doc.data());
        return review;
      }).toList();
      reviews.value = fetchedReviews;
      print(" Fetched ${reviews.length} reviews for bookId: $bookId");
    } catch (e) {
      print(" Error fetching reviews: $e");
    }
  }

  Future<void> _fetchUsersData(Set<String> userIds) async {
    try {
      final userDocs = await Future.wait(
        userIds.map(
          (userId) =>
              FirebaseFirestore.instance.collection('users').doc(userId).get(),
        ),
      );
      for (var doc in userDocs) {
        if (doc.exists) {
          _userCache[doc.id] = doc.data() ?? {};
        }
      }
      update();
    } catch (e) {
      print(" Error fetching users data: $e");
    }
  }

  String getUserName(String userId) {
    return _userCache[userId]?['name'] ?? 'Unknown';
  }

  String getUserPhotoUrl(String userId) {
    return _userCache[userId]?['photoUrl'] ?? '';
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
