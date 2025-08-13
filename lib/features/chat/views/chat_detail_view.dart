import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:booksi/common/styles/colors.dart';
import '../controllers/chat_controller.dart';
import '../services/chat_service.dart';

class ChatDetailView extends StatefulWidget {
  const ChatDetailView({
    super.key,
    required this.chatId,
    required this.currentUserId,
    this.appBarTitle,
    this.otherUserName,
    this.otherUserPhotoUrl,
  });

  final String chatId;
  final String currentUserId;
  final String? appBarTitle;
  final String? otherUserName;
  final String? otherUserPhotoUrl;

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  late final ChatController _controller;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = ChatController(service: ChatService());
    _controller.addListener(_onUpdate);
    _controller.watchChatMessages(
      chatId: widget.chatId,
      currentUserId: widget.currentUserId,
    );
    _controller.markAllAsRead(
      chatId: widget.chatId,
      currentUserId: widget.currentUserId,
    );
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _controller.messages;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = isDark ? AppColors.white : AppColors.white;
    final Color pageBg = isDark ? AppColors.black : AppColors.background;
    final Color appBarBg = isDark ? AppColors.black : AppColors.brown;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBg,
        title: _ChatTitle(
          titleFallback: widget.appBarTitle ?? 'chat'.tr,
          name: widget.otherUserName,
          photoUrl: widget.otherUserPhotoUrl,
          textColor: primaryText,
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryText),
      ),
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg.author.id == widget.currentUserId;
                  final text = msg is types.TextMessage ? msg.text : '';
                  final time = DateTime.fromMillisecondsSinceEpoch(
                    msg.createdAt ?? DateTime.now().millisecondsSinceEpoch,
                  );
                  return _MessageBubble(isMe: isMe, text: text, time: time);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.black : AppColors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.white.withOpacity(0.12)
                        : AppColors.olive.withOpacity(0.6),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.black.withOpacity(0.4)
                        : AppColors.dark.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _ComposerField(
                      controller: _textController,
                      focusNode: _focusNode,
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _SendButton(onPressed: _send, isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _controller.sendText(
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      text: text,
    );
    _textController.clear();
    _focusNode.requestFocus();
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.isMe,
    required this.text,
    required this.time,
  });

  final bool isMe;
  final String text;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bubbleColor = isMe
        ? AppColors.brown
        : (isDark ? AppColors.dark : AppColors.white);
    final Color textColor = isMe
        ? AppColors.white
        : (isDark ? AppColors.white : AppColors.dark);
    final BorderRadius radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMe ? 16 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 16),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: radius,
            border: isMe
                ? null
                : Border.all(
                    color: isDark
                        ? AppColors.olive.withOpacity(0.3)
                        : AppColors.olive.withOpacity(0.7),
                  ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppColors.black.withOpacity(0.45)
                    : AppColors.dark.withOpacity(0.05),
                offset: const Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15, height: 1.3),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(time),
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _ComposerField extends StatelessWidget {
  const _ComposerField({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.black : AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.white.withOpacity(0.12)
              : AppColors.brown.withOpacity(0.4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            Icons.message_outlined,
            color: isDark
                ? AppColors.white.withOpacity(0.5)
                : AppColors.teaMilk,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSubmitted(),
              style: TextStyle(
                color: isDark ? AppColors.white : AppColors.dark,
              ),
              decoration: InputDecoration(
                hintText: 'type_message'.tr,
                hintStyle: TextStyle(
                  color: isDark
                      ? AppColors.white.withOpacity(0.5)
                      : AppColors.teaMilk,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onPressed, required this.isDark});

  final VoidCallback onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brown,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.send, color: AppColors.white, size: 20),
        ),
      ),
    );
  }
}

class _ChatTitle extends StatelessWidget {
  const _ChatTitle({
    required this.titleFallback,
    required this.textColor,
    this.name,
    this.photoUrl,
  });

  final String titleFallback;
  final String? name;
  final String? photoUrl;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final String title = (name == null || name!.trim().isEmpty)
        ? titleFallback
        : name!;
    final String url = photoUrl ?? '';
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
          backgroundColor: Colors.transparent,
          child: url.isEmpty
              ? const Icon(Icons.person_outline, color: AppColors.brown)
              : null,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
