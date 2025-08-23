import 'package:flutter/material.dart';
import 'package:booksi/common/styles/colors.dart';

import 'chat_bot_controller.dart';
import 'chat_bot_service.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  late final ChatBotController _controller;
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = ChatBotController(service: ChatBotService());
    _controller.addListener(_onUpdate);
    _controller.watch(userId: widget.currentUserId);
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.black : AppColors.background;
    final messages = _controller.messages;
    if (widget.currentUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('IBook Chat Bot'),
          backgroundColor: isDark ? AppColors.black : AppColors.brown,
        ),
        body: const Center(child: Text('Please sign in to use the chat bot.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('IBook AI Assistant'),
        backgroundColor: isDark ? AppColors.black : AppColors.brown,
      ),
      backgroundColor: bg,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final m = messages[index];
                final isMe = m.sender == 'user';
                return _Bubble(isMe: isMe, text: m.text, time: m.createdAt);
              },
            ),
          ),
          _Composer(
            controller: _text,
            focusNode: _focus,
            onSend: () async {
              final text = _text.text.trim();
              if (text.isEmpty) return;
              _text.clear();
              _focus.requestFocus();
              try {
                await _controller.send(
                  userId: widget.currentUserId,
                  text: text,
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to get bot reply: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.black : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.white.withOpacity(0.12)
                : AppColors.olive.withOpacity(0.6),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Ask about books... (title, author, genre, etc.)',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.brown,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onSend,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.send, color: AppColors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.isMe, required this.text, this.time});

  final bool isMe;
  final String text;
  final DateTime? time;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = isMe
        ? AppColors.brown
        : (isDark ? AppColors.dark : AppColors.white);
    final textColor = isMe
        ? AppColors.white
        : (isDark ? AppColors.white : AppColors.dark);
    final radius = BorderRadius.only(
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
                _formatTime(time ?? DateTime.now()),
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
