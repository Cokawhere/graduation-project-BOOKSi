import 'package:get/get.dart';
import 'book_model.dart';
import 'shop_services.dart';

class ShopController extends GetxController {
  var isLoading = true.obs;
  var allBooks = <Book>[].obs;
  var bestSellingBooks = <Book>[].obs;
  var newArrivalBooks = <Book>[].obs;
  var filteredBooks = <Book>[].obs;
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
}
