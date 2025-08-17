import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booksi/common/styles/colors.dart';
import 'package:booksi/features/profile/services/profile_service.dart';
import 'package:booksi/features/notifications/services/notification_service.dart';
import 'package:get/utils.dart';

import '../controllers/chat_controller.dart';
import '../services/chat_service.dart';
import '../views/chat_detail_view.dart';

class ContactSellerButton extends StatefulWidget {
  const ContactSellerButton({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
  });

  final String currentUserId;
  final String otherUserId;
  final String bookId;
  final String bookTitle;
  final String bookAuthor;

  @override
  State<ContactSellerButton> createState() => _ContactSellerButtonState();
}

class _ContactSellerButtonState extends State<ContactSellerButton> {
  bool _loading = false;
  late final ChatController _controller;
  final FirebaseService _profileService = FirebaseService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _controller = ChatController(service: ChatService());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePressed() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final seller = await _profileService.getUserById(widget.otherUserId);
      final chatId = await _controller.openChatAndSendIntro(
        currentUserId: widget.currentUserId,
        otherUserId: widget.otherUserId,
        bookId: widget.bookId,
        bookTitle: widget.bookTitle,
        bookAuthor: widget.bookAuthor,
      );

      await _notificationService.createBookRequestNotification(
        userId: widget.otherUserId,
        bookTitle: widget.bookTitle,
      );

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatDetailView(
            chatId: chatId,
            currentUserId: widget.currentUserId,
            appBarTitle: seller?.name ?? 'Chat',
            otherUserName: seller?.name,
            otherUserPhotoUrl: seller?.photoUrl,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isOwner =
        currentUserId != null && currentUserId == widget.otherUserId;
    ;
    return ElevatedButton(
      onPressed: isOwner
          ? null
          : _loading
          ? null
          : _handlePressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 210, 151, 125),
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      ),
      child: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
          : Text(
              'chat_with_owner'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
    );
  }
}
