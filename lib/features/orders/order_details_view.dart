import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:booksi/common/styles/colors.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.brown,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'Order not found',
                style: TextStyle(color: AppColors.dark),
              ),
            );
          }

          final data = snapshot.data!.data()!;
          final createdAt = _toDateTime(data['createdAt']);
          final updatedAt = _toDateTime(data['updatedAt']);
          final items = (data['items'] as List?) ?? const [];
          final buyer = (data['buyerInfo'] as Map?) ?? const {};
          final payment = (data['payment'] as Map?) ?? const {};
          final status = (data['status'] ?? '').toString();
          final amount = (payment['amount'] is num)
              ? (payment['amount'] as num).toDouble()
              : 0.0;
          final currency = (payment['currency'] ?? 'EGP').toString();
          final paidAt = _toDateTime(payment['paidAt']);
          final transactionId = (payment['transactionId'] ?? '').toString();
          final method = (payment['method'] ?? '').toString();
          // Hide raw payment status; we will infer paid by paidAt/amount
          final paymentStatus = '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Section(
                  title: 'Summary',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryRow(
                        label: 'Order ID',
                        value: orderId,
                        isMonospace: true,
                      ),
                      _SummaryRow(
                        label: 'Created',
                        value: _formatDate(createdAt),
                      ),
                      if (updatedAt != null)
                        _SummaryRow(
                          label: 'Updated',
                          value: _formatDate(updatedAt),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Chip(label: status.isEmpty ? 'pending' : status),
                        ],
                      ),
                    ],
                  ),
                ),

                _Section(
                  title: 'Buyer Info',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryRow(
                        label: 'Name',
                        value: (buyer['name'] ?? '').toString(),
                      ),
                      _SummaryRow(
                        label: 'Phone',
                        value: (buyer['phone'] ?? '').toString(),
                      ),
                      _SummaryRow(
                        label: 'Address',
                        value: _joinNotEmpty([
                          (buyer['address'] ?? '').toString(),
                          (buyer['city'] ?? '').toString(),
                          (buyer['government'] ?? '').toString(),
                        ]),
                      ),
                      if ((buyer['note'] ?? '').toString().isNotEmpty)
                        _SummaryRow(
                          label: 'Note',
                          value: (buyer['note'] ?? '').toString(),
                        ),
                    ],
                  ),
                ),

                _Section(
                  title: 'Items (${items.length})',
                  child: Column(
                    children: items.map<Widget>((raw) {
                      final map = (raw as Map);
                      final title = (map['title'] ?? '').toString();
                      final author = (map['author'] ?? '').toString();
                      final price = (map['price'] is num)
                          ? (map['price'] as num).toDouble()
                          : 0.0;
                      final qty = (map['quantity'] is num)
                          ? (map['quantity'] as num).toInt()
                          : 1;
                      final image = (map['coverImage'] ?? '').toString();
                      return _ItemTile(
                        title: title,
                        author: author,
                        imageUrl: image,
                        price: price,
                        quantity: qty,
                        currency: currency,
                      );
                    }).toList(),
                  ),
                ),

                _Section(
                  title: 'Payment',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryRow(label: 'Method', value: method.toUpperCase()),
                      _SummaryRow(
                        label: 'Amount',
                        value: '$currency ${amount.toStringAsFixed(2)}',
                      ),
                      if (transactionId.isNotEmpty)
                        _SummaryRow(
                          label: 'Transaction ID',
                          value: transactionId,
                          isMonospace: true,
                        ),
                      if (paidAt != null)
                        _SummaryRow(
                          label: 'Paid At',
                          value: _formatDate(paidAt),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static String _formatDate(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('MMM d, y • h:mm a').format(value);
  }

  static String _joinNotEmpty(List<String> parts) {
    return parts.where((e) => e.trim().isNotEmpty).join(', ');
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF121212)
            : AppColors.white,
        border: Border.all(color: AppColors.teaMilk),
        borderRadius: BorderRadius.circular(12),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: AppColors.dark.withOpacity(0.04),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isMonospace = false,
  });

  final String label;
  final String value;
  final bool isMonospace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(
                fontFamily: isMonospace ? 'monospace' : null,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.positive});

  final String label;
  final bool? positive;

  @override
  Widget build(BuildContext context) {
    final bool isPositive = positive == true;
    final Color bg = isPositive ? Colors.green.shade100 : AppColors.teaMilk;
    final Color fg = isPositive ? Colors.green.shade800 : AppColors.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.currency,
  });

  final String title;
  final String author;
  final String imageUrl;
  final double price;
  final int quantity;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 56,
              height: 56,
              color: AppColors.teaMilk.withOpacity(0.4),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Icon(Icons.menu_book, color: AppColors.brown),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('x$quantity', style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 12),
          Text(
            '$currency ${(price * quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
