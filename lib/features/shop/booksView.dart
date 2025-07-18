import 'package:flutter/material.dart';
import 'package:booksi/features/shop/book_model.dart';
import 'package:booksi/common/widgets/custom-book-cart.dart';

class BooksView extends StatelessWidget {
  final String title;
  final List<Book> books;

  const BooksView({super.key, required this.title, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
            price: book.price?.toString() ?? "0",
            onAdd: () {},
            index: index,
          );
        },
      ),
    );
  }
}
