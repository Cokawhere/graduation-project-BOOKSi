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
  var currentFilters = <String, dynamic>{}.obs;
  RxBool isFilteringActive = false.obs;

  @override
  void onInit() {
    super.onInit();

    isLoading.value = true;
    ShopServices.getAllApprovedBooksStream().listen((books) {
      allBooks.value = books;
      isLoading.value = false;

      print("onInit: isFilteringActive: ${isFilteringActive.value}");
      if (isFilteringActive.value) {
        filteredBooks.value = _applyFilterLogic(allBooks, currentFilters);
      } else {
        filteredBooks.clear();
      }
      filteredBooks.refresh();
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
    if (query.isEmpty && !isFilteringActive.value) {
      filteredBooks.clear();
    } else {
      List<Book> temp = allBooks;
      if (isFilteringActive.value) {
        temp = _applyFilterLogic(allBooks, currentFilters);
      }
      if (query.isNotEmpty) {
        final lower = query.toLowerCase();
        temp = temp
            .where(
              (book) =>
                  book.title.toLowerCase().contains(lower) ||
                  book.author.toLowerCase().contains(lower),
            )
            .toList();
      }
      filteredBooks.value = temp;
    }
  }

  void applyFilters(Map<String, dynamic>? filters) {
    if (filters == null) {
      isFilteringActive.value = false;
      currentFilters.clear();
      filteredBooks.clear();
      searchQuery.value = '';
    } else {
      currentFilters.value = Map<String, dynamic>.from(filters);
      isFilteringActive.value = true;
      filteredBooks.value = _applyFilterLogic(allBooks, filters);
      originalFilteredBooks = filteredBooks.toList();
    }
  }

  List<Book> _applyFilterLogic(List<Book> books, Map<String, dynamic> filters) {
    List<Book> temp = books.where((b) => b.quantity >= 1).toList();

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

    if ((filters['rating'] ?? '').isNotEmpty) {
      final ratingStr = filters['rating'];
      final double minRating =
          double.tryParse(
            RegExp(r'(\d+\.\d+)').firstMatch(ratingStr)?.group(1) ?? '0',
          ) ??
          0;
      temp = temp.where((b) => b.averageRating >= minRating).toList();
    }

    return temp;
  }
}
