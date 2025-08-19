import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booksi/common/styles/colors.dart';
import 'chat_detail_view.dart';
import 'package:booksi/features/profile/services/profile_service.dart';
import 'package:booksi/features/profile/models/profile.dart';
import 'package:booksi/features/chat_bot/chat_bot_view.dart';
import '../chat_models.dart';
import '../controllers/chat_controller.dart';
import '../services/chat_service.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key, required this.currentUserId, this.onOpenChat});

  final String currentUserId;
  final void Function(ChatPreview preview)? onOpenChat;

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late final ChatController _controller;
  final FirebaseService _profileService = FirebaseService();
  final Map<String, UserModel> _userCache = {};

  @override
  void initState() {
    super.initState();
    _controller = ChatController(service: ChatService());
    _controller.watchUserChats(userId: widget.currentUserId);
    _controller.addListener(_onUpdate);
  }

  void _onUpdate() {
    if (mounted) {
      _prefetchUsersForChats(_controller.chatPreviews);
      setState(() {});
    }
  }

  void _prefetchUsersForChats(List<ChatPreview> chats) {
    for (final preview in chats) {
      final otherId = _otherUserId(preview);
      if (otherId.isEmpty) continue;
      // Only fetch if the preview doesn't have the name/photo populated
      final needsFetch =
          preview.otherParticipantName.isEmpty ||
          preview.otherParticipantPhotoUrl.isEmpty;
      if (needsFetch && !_userCache.containsKey(otherId)) {
        _profileService.getUserById(otherId).then((user) {
          if (user != null && mounted) {
            setState(() => _userCache[otherId] = user);
          }
        });
      }
    }
  }

  String _otherUserId(ChatPreview preview) {
    return preview.participants.firstWhere(
      (id) => id != widget.currentUserId,
      orElse: () => '',
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    final Color surface = isDark ? const Color(0xFF121212) : AppColors.white;
    final Color border = isDark
        ? Colors.white10
        : AppColors.olive.withOpacity(0.6);
    final Color primaryText = isDark ? AppColors.white : AppColors.dark;
    final Color secondaryText = isDark
        ? Colors.white70
        : AppColors.dark.withOpacity(0.8);
    final Color muted = isDark ? Colors.white38 : AppColors.teaMilk;

    final chats = _controller.chatPreviews;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'chat'.tr,
          style: TextStyle(color: primaryText, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Chat Bot',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ChatBotView(currentUserId: widget.currentUserId),
                ),
              );
            },
            icon: Icon(Icons.smart_toy_outlined, color: primaryText),
          ),
        ],
      ),
      body: chats.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 48, color: muted),
                  const SizedBox(height: 12),
                  Text(
                    'no_messages'.tr,
                    style: TextStyle(
                      color: primaryText.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'start_conversation'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: secondaryText, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final preview = chats[index];
                final last = preview.lastMessage;
                final hasUnread =
                    last != null &&
                    !last.read &&
                    last.senderId != widget.currentUserId;

                final otherId = _otherUserId(preview);
                final name = preview.otherParticipantName.isNotEmpty
                    ? preview.otherParticipantName
                    : (_userCache[otherId]?.name ?? 'User');
                final photoUrl = preview.otherParticipantPhotoUrl.isNotEmpty
                    ? preview.otherParticipantPhotoUrl
                    : (_userCache[otherId]?.photoUrl ?? '');

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (widget.onOpenChat != null) {
                      widget.onOpenChat!(preview);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatDetailView(
                            chatId: preview.chatId,
                            currentUserId: widget.currentUserId,
                            appBarTitle: preview.bookTitle,
                            otherUserName: name,
                            otherUserPhotoUrl: photoUrl,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: AppColors.dark.withOpacity(0.04),
                                offset: const Offset(0, 2),
                                blurRadius: 6,
                              ),
                            ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _Avatar(url: photoUrl, name: name),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: primaryText,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatTime(preview.updatedAt),
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              if (preview.bookTitle.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  preview.bookTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.amber.shade200
                                        : AppColors.brown,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                last == null
                                    ? 'start_conversation'.tr
                                    : last.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: secondaryText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (hasUnread)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.amber : AppColors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 1) return 'now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    return '${time.month}/${time.day}/${time.year}';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.name});

  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFromName(name);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : AppColors.olive.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: isDark
            ? const Color(0xFF1E1E1E)
            : AppColors.background,
        backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
        child: url.isEmpty
            ? Text(
                initials,
                style: TextStyle(
                  color: isDark ? AppColors.white : AppColors.dark,
                  fontWeight: FontWeight.w700,
                ),
              )
            : null,
      ),
    );
  }

  String _initialsFromName(String value) {
    if (value.trim().isEmpty) return '?';
    final parts = value.trim().split(RegExp(r"\s+"));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}
