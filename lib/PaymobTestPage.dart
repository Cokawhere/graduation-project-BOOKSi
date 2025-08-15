// import 'package:flutter/material.dart';
// import 'package:flutter_paymob/flutter_paymob.dart';
// import 'dart:convert';

// class PaymobTestPage extends StatelessWidget {
//   const PaymobTestPage({super.key});

//   void _payWithCard(BuildContext context) {
//     FlutterPaymob.instance.payWithCard(
//       context: context,
//       currency: "EGP",
//       amount: 550, 
//       onPayment: (response) {
//         bool paymentSuccess =
//             response.success ||
//             (response.responseCode == "APPROVED" &&
//                 (response.transactionID?.isNotEmpty ?? false));

        
//         final paymentData = {
//           "method": "Paymob",
//           "transactionId": response.transactionID ?? "",
//           "paidAt": paymentSuccess
//               ? DateTime.now().toUtc().toIso8601String()
//               : null,
//           "amount": 550,
//           "currency": "EGP",
//           "status": paymentSuccess ? "paid" : "failed",
//           "message": response.message ?? "",
//           "responseCode": response.responseCode ?? "",
//         };

//         final orderSchema = {
//           "orderId": "ORD-${DateTime.now().millisecondsSinceEpoch}",
//           "userId": "abc123",
//           "status": paymentSuccess ? "paid" : "pending",
//           "createdAt": DateTime.now().toUtc().toIso8601String(),
//           "updatedAt": DateTime.now().toUtc().toIso8601String(),
//           "items": [
//             {
//               "bookId": "xyz456",
//               "title": "The Subtle Art of Not Giving a F*ck",
//               "price": 150,
//               "quantity": 1,
//               "image": "https://example.com/book.jpg",
//               "author": "Mark Manson",
//             },
//             {
//               "bookId": "abc789",
//               "title": "Atomic Habits",
//               "price": 200,
//               "quantity": 2,
//               "image": "https://example.com/atomic.jpg",
//               "author": "James Clear",
//             },
//           ],
//           "shippingInfo": {
//             "name": "Rana Ahmed",
//             "phone": "0123456789",
//             "address": "شارع النيل، عمارة ٥",
//             "city": "Cairo",
//             "government": "Giza",
//             "note": "لو مش موجودة حط الكتاب عند الجيران",
//           },
//           "payment": paymentData,
//           "totalPrice": 550,
//         };

//         print(jsonEncode(orderSchema));
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Paymob Test")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _payWithCard(context),
//           child: const Text("Pay with Card"),
//         ),
//       ),
//     );
//   }
// }
