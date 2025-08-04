import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/custom-book-cart.dart';
import '../cart/cart_view.dart';
import '../shop/book_model.dart';

class BooksView extends StatelessWidget {
  final String title;
  final List<Book> books;

  const BooksView({super.key, required this.title, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 30),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black87, size: 33),
              onPressed: () {
                Get.to(() => Cartview());
              },
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        itemCount: books.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 7,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(
            id:book.id,
            imageUrl: book.coverImage,
            title: book.title,
            author: book.author,
            price: book.price.toString(),
            index: index,
            ownerId: book.ownerId,
            averageRating: book.averageRating,
            availableFor: book.availableFor,
          );
        },
      ),
    );
  }
}
