import 'package:get/get.dart';
import 'book_model.dart';
import 'shop_services.dart';

class ShopController extends GetxController {
  var isLoading = true.obs;
  var allBooks = <Book>[].obs;
  var bestSellingBooks = <Book>[].obs;
  var newArrivalBooks = <Book>[].obs;
  var filteredBooks = <Book>[].obs;
  var originalFilteredBooks = <Book>[];
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    isLoading.value = true;
    ShopServices.getAllApprovedBooksStream().listen((books) {
      allBooks.value = books;
      isLoading.value = false;
      if (searchQuery.value.isNotEmpty) {
        filterBooks(searchQuery.value);
      }
    });

    ShopServices.getBestSellingBooksStream().listen((books) {
      bestSellingBooks.value = books;
    });

    ShopServices.getNewArrivalBooksStream().listen((books) {
      newArrivalBooks.value = books;
    });
  }

  void filterBooks(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredBooks.clear();
    } else {
      final lower = query.toLowerCase();
      filteredBooks.value = allBooks
          .where(
            (book) =>
                book.title.toLowerCase().contains(lower) ||
                book.author.toLowerCase().contains(lower),
          )
          .toList();
    }
  }

  void applyFilters(Map filters) {
    List<Book> temp = allBooks;

    if ((filters['governorate'] ?? '').isNotEmpty) {
      temp = temp.where((b) => b.location == filters['governorate']).toList();
    }

    if ((filters['categories'] as List).isNotEmpty) {
      temp = temp
          .where((b) => (filters['categories'] as List).contains(b.genre))
          .toList();
    }

    if (filters['priceRange'] != null) {
      final range = filters['priceRange'];
      temp = temp
          .where((b) => b.price >= range.start && b.price <= range.end)
          .toList();
    }

    if ((filters['conditions'] as List).isNotEmpty) {
      temp = temp
          .where((b) => (filters['conditions'] as List).contains(b.condition))
          .toList();
    }

    if ((filters['availableFor'] as List).isNotEmpty) {
      temp = temp
          .where(
            (b) => (filters['availableFor'] as List).contains(b.availableFor),
          )
          .toList();
    }

    if ((filters['status'] as List).isNotEmpty) {
      temp = temp
          .where((b) => (filters['status'] as List).contains(b.status))
          .toList();
    }

    if ((filters['rating'] ?? '').isNotEmpty) {
      final ratingStr = filters['rating'];
      final double minRating =
          double.tryParse(
            RegExp(r'(\d+\.\d+)').firstMatch(ratingStr)?.group(1) ?? '0',
          ) ??
          0;
      temp = temp.where((b) => b.averageRating >= minRating).toList();
    }

    filteredBooks.value = temp;
    originalFilteredBooks = temp;

    void filterBooks(String query) {
      searchQuery.value = query;

      if (query.isEmpty) {
        filteredBooks.value = originalFilteredBooks;
      } else {
        final lower = query.toLowerCase();
        filteredBooks.value = originalFilteredBooks
            .where(
              (b) =>
                  b.title.toLowerCase().contains(lower) ||
                  b.author.toLowerCase().contains(lower),
            )
            .toList();
      }
    }
  }
}
