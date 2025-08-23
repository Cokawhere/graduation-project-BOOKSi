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
      print("Books received in controller: ${books.length}");
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
      print("Best selling books received: ${books.length}");
      bestSellingBooks.value = books;
    });

    ShopServices.getNewArrivalBooksStream().listen((books) {
      print("New arrival books received: ${books.length}");
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
      print("Filtered books after search: ${filteredBooks.length}");
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
      print("Filtered books after applying filters: ${filteredBooks.length}");
    }
  }

  List<Book> _applyFilterLogic(List<Book> books, Map<String, dynamic> filters) {
    List<Book> temp = books.where((b) => b.quantity >= 1).toList();
    print("Books after quantity filter: ${temp.length}");

    if ((filters['governorate'] ?? '').isNotEmpty) {
      temp = temp.where((b) => b.location == filters['governorate']).toList();
      print("Books after governorate filter: ${temp.length}");
    }

    if ((filters['categories'] as List).isNotEmpty) {
      temp = temp
          .where((b) => (filters['categories'] as List).contains(b.genre))
          .toList();
      print("Books after categories filter: ${temp.length}");
    }

    if (filters['priceRange'] != null) {
      final range = filters['priceRange'];
      temp = temp
          .where((b) => b.price >= range.start && b.price <= range.end)
          .toList();
      print("Books after price range filter: ${temp.length}");
    }

    if ((filters['conditions'] as List).isNotEmpty) {
      temp = temp
          .where((b) => (filters['conditions'] as List).contains(b.condition))
          .toList();
      print("Books after conditions filter: ${temp.length}");
    }

    if ((filters['availableFor'] as List).isNotEmpty) {
      temp = temp
          .where(
            (b) => (filters['availableFor'] as List).contains(b.availableFor),
          )
          .toList();
      print("Books after availableFor filter: ${temp.length}");
    }

    if ((filters['rating'] ?? '').isNotEmpty) {
      final ratingStr = filters['rating'];
      final double minRating =
          double.tryParse(
            RegExp(r'(\d+\.\d+)').firstMatch(ratingStr)?.group(1) ?? '0',
          ) ??
          0;
      temp = temp.where((b) => b.averageRating >= minRating).toList();
      print("Books after rating filter: ${temp.length}");
    }

    return temp;
  }
}
