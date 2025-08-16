import 'package:booksi/features/order-summary/Payment%20Successfully.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../cart/cart_controller.dart';
import '../shipping information/shipping-information_controller.dart';
import '../notifications/services/notification_service.dart';

class OrderSummaryController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  Future<void> processPaymentAndSaveOrder(
    Map<String, dynamic> shippingInfo,
    double totalAmount,
    BuildContext context,
  ) async {
    double total = cartController.cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    double finalTotal = total + 0;

    await FlutterPaymob.instance.payWithCard(
      context: context,
      currency: "EGP",
      amount: finalTotal,
      onPayment: (response) async {
        bool paymentSuccess =
            response.success ||
            (response.responseCode == "APPROVED" &&
                (response.transactionID?.isNotEmpty ?? false));

        if (paymentSuccess) {
          final userId =
              FirebaseAuth.instance.currentUser?.uid ?? "unknown_user";
          final orderId = const Uuid().v4();
          final orderSchema = {
            "orderId": orderId,
            "userId": userId,
            "status": "paid",
            "createdAt": Timestamp.now(),
            "updatedAt": Timestamp.now(),
            "items": cartController.cartItems
                .map(
                  (item) => {
                    "bookId": item['bookId'],
                    "title": item['title'],
                    "price": item['price'],
                    "quantity": item['quantity'],
                    "coverImage": item['coverImage'],
                    "author": item['author'],
                  },
                )
                .toList(),
            "buyerInfo": {
              "name": shippingInfo['name'] ?? 'N/A',
              "phone": shippingInfo['phone'] ?? 'N/A',
              "address": shippingInfo['address'] ?? 'N/A',
              "city": shippingInfo['city'] ?? 'N/A',
              "government": shippingInfo['government'] ?? 'N/A',
              "note": shippingInfo['note'],
            },
            "payment": {
              "method": "card",
              "transactionId": response.transactionID ?? "",
              "paidAt": Timestamp.now(),
              "amount": finalTotal,
              "currency": "EGP",
              "status": "paid",
            },
            "totalPrice": finalTotal,
          };

          await _firestore.collection('orders').doc(orderId).set(orderSchema);
          Get.offAll(PaymentSuccessView());
          Get.snackbar("Success", "Payment completed successfully!");

          for (var item in cartController.cartItems) {
            final bookDoc = await _firestore
                .collection('books')
                .doc(item['bookId'])
                .get();
            if (bookDoc.exists) {
              final bookData = bookDoc.data() as Map<String, dynamic>;
              final sellerId = bookData['ownerId'] as String?;

              if (sellerId != null && sellerId.isNotEmpty) {
                await _notificationService.createBookSoldNotification(
                  sellerId: sellerId,
                  bookTitle: item['title'],
                  buyerId: userId,
                );
              }
            }

            await cartController.removeFromCart(item['bookId']);
          }

          Get.delete<ShippingInfoController>();
        } else {
          Get.snackbar("Error", "Payment failed: ${response.message}");
        }
      },
    );
  }
}
