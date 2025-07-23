import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/custom-book-cart.dart';
import '../cart/cart_view.dart';
import '../shop/book_model.dart';

class BooksView extends StatelessWidget {
  final String title;
  final List<Book> books;

  BooksView({super.key, required this.title, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 30),
            onPressed: () {
              Get.to(() => Cartview());
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(
            imageUrl: book.coverImage,
            title: book.title,
            author: book.author,
            price: book.price.toString(),
            onAdd: () {},
            index: index,
          );
        },
      ),
    );
  }
}
