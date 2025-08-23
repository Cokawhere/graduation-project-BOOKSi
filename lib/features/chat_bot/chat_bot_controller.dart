import 'dart:async';

import 'package:flutter/foundation.dart';

import 'chat_bot_message.dart';
import 'chat_bot_service.dart';

class ChatBotController extends ChangeNotifier {
  ChatBotController({required ChatBotService service}) : _service = service;

  final ChatBotService _service;

  StreamSubscription<List<ChatBotMessage>>? _sub;
  List<ChatBotMessage> _messages = [];
  List<ChatBotMessage> get messages => _messages;

  void watch({required String userId}) {
    _sub?.cancel();
    _sub = _service.watchMessages(userId: userId).listen((list) {
      _messages = list;
      notifyListeners();
    });
  }

  Future<void> send({required String userId, required String text}) async {
    await _service.sendAndReply(userId: userId, userText: text);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
