import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../chat_models.dart';
import '../services/chat_service.dart';

class ChatController extends ChangeNotifier {
  ChatController({required ChatService service}) : _service = service;

  final ChatService _service;

  String? _currentChatId;
  String? get currentChatId => _currentChatId;

  StreamSubscription<List<types.Message>>? _messagesSub;
  List<types.Message> _messages = [];
  List<types.Message> get messages => _messages;

  StreamSubscription<List<ChatPreview>>? _chatsSub;
  List<ChatPreview> _chatPreviews = [];
  List<ChatPreview> get chatPreviews => _chatPreviews;

  Future<String> openOrCreateChat({
    required String currentUserId,
    required String otherUserId,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
    String? initialMessage,
  }) async {
    final chatId = await _service.createOrGetChat(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      bookId: bookId,
      bookTitle: bookTitle,
      bookAuthor: bookAuthor,
      initialMessageContent: initialMessage,
    );
    _currentChatId = chatId;
    notifyListeners();
    return chatId;
  }

  /// Opens or creates a chat and always sends an introductory message
  /// containing the book title and author.
  Future<String> openChatAndSendIntro({
    required String currentUserId,
    required String otherUserId,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
  }) async {
    final welcome = 'Hello! I want to buy "$bookTitle" by $bookAuthor.';
    final chatId = await _service.createOrGetChat(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      bookId: bookId,
      bookTitle: bookTitle,
      bookAuthor: bookAuthor,
      initialMessageContent: welcome,
    );
    _currentChatId = chatId;
    notifyListeners();
    return chatId;
  }

  void watchUserChats({required String userId}) {
    _chatsSub?.cancel();
    _chatsSub = _service.watchUserChats(userId: userId).listen((list) {
      _chatPreviews = list;
      notifyListeners();
    });
  }

  /// Force-refresh chats from server and update current previews immediately.
  Future<void> refreshUserChats({required String userId}) async {
    final list = await _service.fetchUserChatsOnce(userId: userId);
    _chatPreviews = list;
    notifyListeners();
  }

  void watchChatMessages({
    required String chatId,
    required String currentUserId,
  }) {
    _messagesSub?.cancel();
    _currentChatId = chatId;
    _messagesSub = _service
        .watchMessagesAsTypes(chatId: chatId, currentUserId: currentUserId)
        .listen((list) {
          _messages = list;
          notifyListeners();
        });
  }

  Future<void> sendText({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    await _service.sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: text,
      type: 'text',
    );
  }

  Future<void> markAllAsRead({
    required String chatId,
    required String currentUserId,
  }) async {
    await _service.markAllAsRead(chatId: chatId, currentUserId: currentUserId);
  }

  @override
  void dispose() {
    _messagesSub?.cancel();
    _chatsSub?.cancel();
    super.dispose();
  }
}
