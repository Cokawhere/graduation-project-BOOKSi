
import 'package:get/get.dart';

import 'book_model.dart';
import 'shop_services.dart';

class ShopController extends GetxController {
  var isLoading = false.obs;
  var bestSellingBooks = <Book>[].obs;
  var trendingBooks = <Book>[].obs;
  var newArrivalBooks = <Book>[].obs;
  var allBooks = <Book>[].obs;

  var searchQuery = ''.obs;
  var filteredBooks = <Book>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

 void fetchBooks() async {
    try {
      isLoading.value = true;

      bestSellingBooks.value = await ShopServices.getBestSellingBooks();
      newArrivalBooks.value = await ShopServices.getNewArrivalBooks();
      allBooks.value = await ShopServices.getAllApprovedBooks();
    } catch (e) {
      print(" Error fetching books: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterBooks(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredBooks.clear();
    } else {
      final lower = query.toLowerCase();

      filteredBooks.value = allBooks.where((book) =>
        book.title.toLowerCase().contains(lower) ||
        book.author.toLowerCase().contains(lower)).toList();
    }
  }
}
