import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'chat_bot_message.dart';

class ChatBotService {
  ChatBotService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messagesCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chatMessages');
  }

  Stream<List<ChatBotMessage>> watchMessages({required String userId}) {
    return _messagesCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((d) => ChatBotMessage.fromJson(d.data(), id: d.id))
              .toList(),
        );
  }

  Future<void> addUserMessage({
    required String userId,
    required String text,
  }) async {
    await _messagesCollection(userId).add({
      'text': text,
      'sender': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addBotMessage({
    required String userId,
    required String text,
  }) async {
    await _messagesCollection(userId).add({
      'text': text,
      'sender': 'bot',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> _callOpenAI({
    required List<Map<String, String>> messages,
  }) async {
    final envKey = (dotenv.env['OPENAI_API_KEY'] ?? '').trim();
    const defineKey = String.fromEnvironment('OPENAI_API_KEY');
    final apiKey = envKey.isNotEmpty
        ? envKey
        : (defineKey.isNotEmpty ? defineKey : '');
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY is missing');
    }

    // Use Chat Completions style endpoint for broad compatibility
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final body = jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': messages,
      'temperature': 0.3,
      'max_tokens': 400,
    });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content =
          (data['choices'] as List).first['message']['content'] as String;
      return content.trim();
    }

    throw Exception('OpenAI error ${response.statusCode}: ${response.body}');
  }

  Future<void> sendAndReply({
    required String userId,
    required String userText,
  }) async {
    // Store user message first
    await addUserMessage(userId: userId, text: userText);

    final systemPrompt =
        'You are IBook, a helpful assistant that only talks about books. You can discuss book summaries, authors, genres, recommendations, publishing details, reading levels, availability in libraries, and related literary topics. Politely refuse and redirect if asked about anything non-book related. Respond in plain text only. Do not use markdown (no **, __, *, #, backticks), code blocks, emojis, or other special formatting.';

    // Build recent context (last 15 messages)
    final recentQuery = await _messagesCollection(
      userId,
    ).orderBy('createdAt', descending: true).limit(15).get();

    final history =
        recentQuery.docs
            .map((d) => ChatBotMessage.fromJson(d.data(), id: d.id))
            .toList()
          ..sort(
            (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
              b.createdAt ?? DateTime.now(),
            ),
          );

    final chatMessages = <Map<String, String>>[
      {'role': 'system', 'content': systemPrompt},
      for (final m in history)
        {'role': m.sender == 'user' ? 'user' : 'assistant', 'content': m.text},
    ];

    try {
      final reply = await _callOpenAI(messages: chatMessages);
      final plain = _toPlainText(reply);
      await addBotMessage(userId: userId, text: plain);
    } catch (e) {
      await addBotMessage(
        userId: userId,
        text:
            'Sorry, I could not process your request right now. Please try again. ($e)',
      );
    }
  }

  String _toPlainText(String input) {
    var text = input;
    // Code fences: keep inner content
    text = text.replaceAllMapped(
      RegExp(r"```(?:\w+)?\s*([\s\S]*?)\s*```", dotAll: true),
      (m) => m.group(1)?.trim() ?? '',
    );
    // Inline code
    text = text.replaceAllMapped(RegExp(r"`([^`]*)`"), (m) => m.group(1) ?? '');
    // Links and images: [text](url) or ![alt](url) -> text: url
    text = text.replaceAllMapped(
      RegExp(r"!\[([^\]]*)\]\(([^)]+)\)"),
      (m) => ((m.group(1) ?? '').trim().isEmpty)
          ? (m.group(2) ?? '')
          : '${m.group(1)}: ${m.group(2)}',
    );
    text = text.replaceAllMapped(
      RegExp(r"\[([^\]]+)\]\(([^)]+)\)"),
      (m) => '${m.group(1)}: ${m.group(2)}',
    );
    // Headings: drop leading #
    text = text.replaceAll(RegExp(r"^\s{0,3}#{1,6}\s*", multiLine: true), '');
    // Bullets: * or - at line start -> '- '
    text = text.replaceAll(RegExp(r"^\s*\*\s+", multiLine: true), '- ');
    text = text.replaceAll(RegExp(r"^\s*-\s+", multiLine: true), '- ');
    text = text.replaceAll('•', '- ');
    // Emphasis: remove leftover **, __, * and _ markers
    text = text.replaceAll('**', '');
    text = text.replaceAll('__', '');
    text = text.replaceAll('_', '');
    // Remove stray asterisks not used as bullets
    text = text.replaceAll(RegExp(r"(?<!^)\*(?!\s)"), '');
    // Tables: replace pipes with spaces
    text = text.replaceAll('|', ' ');
    // Collapse excessive whitespace
    text = text.replaceAll(RegExp(r"[\t\x0B\f\r]"), ' ');
    text = text.replaceAll(RegExp(r"\n{3,}"), '\n\n');
    text = text.replaceAll(RegExp(r"\s{3,}"), ' ');
    return text.trim();
  }
}
