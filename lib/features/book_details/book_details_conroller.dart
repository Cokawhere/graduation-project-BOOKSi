import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../shop/book_model.dart';
import 'book_details_model.dart';
import 'book_details_services.dart';
import 'review_model.dart';

class BookDetailsController extends GetxController {
  final String bookId;
  final TextEditingController reviewController = TextEditingController();
  var selectedRating = 0.0.obs;
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
      Get.snackbar("", "Failed to load book details");
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
          .where(
            (book) =>
                book.id != bookId &&
                !book.isDeleted &&
                book.approval == "approved",
          )
          .toList();
    } catch (e) {
      print('Error fetching similar books: $e');
    }
  }

  Future<void> fetchReviews() async {
    try {
      print(" Starting fetchReviews for bookId: $bookId");
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('targetId', isEqualTo: bookId)
          .get();
      print("QuerySnapshot docs count: ${querySnapshot.docs.length}");
      final reviewDocs = querySnapshot.docs;
      final reviewerIds = reviewDocs
          .map((doc) => Review.fromMap(doc.data()).reviewerId)
          .toSet();
      await _fetchUsersData(reviewerIds);
      final fetchedReviews = reviewDocs.map((doc) {
        final review = Review.fromMap(doc.data());
        return review;
      }).toList();
      reviews.value = fetchedReviews;
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

  Future<void> checkPurchaseAndShowReviewDialog(
    BuildContext context,
    String bookId,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("", "Login first");
      return;
    }

    bool hasPurchased = await checkIfUserPurchasedBook();
    if (!hasPurchased) {
      Get.snackbar("", "You must purchase this book before writing a review");
      return;
    }

    bool alreadyReviewed = await hasUserReviewedBook();
    if (alreadyReviewed) {
      Get.snackbar("", "You have already reviewed this book");
      return;
    }

    _showReviewDialog(context, bookId);
  }

  Future<bool> hasUserReviewedBook() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('targetId', isEqualTo: bookId)
          .where('reviewerId', isEqualTo: user.uid)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if user reviewed book: $e");
      return false;
    }
  }

  void _showReviewDialog(BuildContext context, String bookId) {
    selectedRating.value = 0;
    reviewController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Review"),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < selectedRating.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        selectedRating.value = index + 1.0;
                        update();
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Write a comment",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => submitReview(bookId),
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitReview(String bookId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (selectedRating.value == 0 || reviewController.text.trim().isEmpty) {
      Get.snackbar(
        "",
        "choose the rating and write a comment before submitting.",
      );
      return;
    }

    final reviewId = Uuid().v4();
    await FirebaseFirestore.instance.collection('reviews').add({
      'targetId': bookId,
      'reviewerId': user.uid,
      'rating': selectedRating.value,
      'comment': reviewController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'reviewId': reviewId,
    });

    await fetchReviews();

    Get.back();
    Get.snackbar("", "Review sent successfully");
  }

  Future<bool> checkIfUserPurchasedBook() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return false;

    try {
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: currentUserId)
          .get();

      for (var orderDoc in ordersSnapshot.docs) {
        final data = orderDoc.data();
        final status = data['status'];
        final items = List<Map<String, dynamic>>.from(data['items']);

        final purchased = items.any((item) => item['bookId'] == book.value?.id);

        if (purchased && (status == 'paid' || status == 'delivered')) {
          return true;
        }
      }
    } catch (e) {
      print("Error checking purchased book: $e");
    }

    return false;
  }

  Future<String> uploadImageToStorage(String bookId, String imageUrl) async {
    return imageUrl.isNotEmpty ? imageUrl : '';
  }

  Future<String> createDynamicLink(String bookId) async {
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://booksi.page.link',
      link: Uri.parse('https://booksi.page.link/book?id=$bookId'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.booksi',
        minimumVersion: 1,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
    );
    return dynamicLink.shortUrl.toString();
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
