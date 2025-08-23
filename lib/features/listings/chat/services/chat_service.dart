import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:booksi/features/profile/services/profile_service.dart';
import 'package:booksi/features/profile/models/profile.dart';

import '../chat_models.dart';

class ChatService {
  ChatService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final FirebaseService _profileService = FirebaseService();

  static const String chatsCollection = 'chats';
  static const String messagesSubcollection = 'messages';


  String _deterministicChatId({required String userA, required String userB}) {
    final sorted = [userA, userB]..sort();
    return 'chat_${sorted.join('_')}';
  }

  Future<String> createOrGetChat({
    required String currentUserId,
    required String otherUserId,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
    String? initialMessageContent,
  }) async {
    // Preferred chat id is based only on participants
    final preferredChatId = _deterministicChatId(
      userA: currentUserId,
      userB: otherUserId,
    );

    final preferredRef = _firestore
        .collection(chatsCollection)
        .doc(preferredChatId);
    final preferredSnap = await preferredRef.get();
    final now = DateTime.now();

    // If the preferred chat exists, update its book info and optionally send intro
    if (preferredSnap.exists) {
      await preferredRef.update({
        'bookId': bookId,
        'bookTitle': bookTitle,
        'bookAuthor': bookAuthor,
        'updatedAt': Timestamp.fromDate(now),
        'lastTimestamp': Timestamp.fromDate(now),
      });

      if (initialMessageContent != null && initialMessageContent.isNotEmpty) {
        await sendMessage(
          chatId: preferredChatId,
          senderId: currentUserId,
          content: initialMessageContent,
          type: 'text',
        );
      }

      return preferredChatId;
    }

    // Fallback: try to find any existing chat between the two users (old per-book chat id)
    final existingBetweenUsersQuery = await _firestore
        .collection(chatsCollection)
        .where('participants', arrayContains: currentUserId)
        .get();

    DocumentSnapshot<Map<String, dynamic>>? existingBetweenUsers;
    for (final doc in existingBetweenUsersQuery.docs) {
      final participants = List<String>.from(
        doc.data()['participants'] ?? const [],
      );
      if (participants.contains(otherUserId)) {
        existingBetweenUsers = doc;
        break;
      }
    }

    if (existingBetweenUsers != null) {
      // Update book info in the found chat
      await existingBetweenUsers.reference.update({
        'bookId': bookId,
        'bookTitle': bookTitle,
        'bookAuthor': bookAuthor,
        'updatedAt': Timestamp.fromDate(now),
        'lastTimestamp': Timestamp.fromDate(now),
      });

      if (initialMessageContent != null && initialMessageContent.isNotEmpty) {
        await sendMessage(
          chatId: existingBetweenUsers.id,
          senderId: currentUserId,
          content: initialMessageContent,
          type: 'text',
        );
      }

      return existingBetweenUsers.id;
    }

    // Otherwise, create the preferred chat
    await preferredRef.set({
      'bookId': bookId,
      'participants': [currentUserId, otherUserId],
      'lastMessage': initialMessageContent ?? '',
      'lastSenderId': initialMessageContent == null ? '' : currentUserId,
      'createdAt': Timestamp.fromDate(now),
      'lastTimestamp': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
    });

    if (initialMessageContent != null && initialMessageContent.isNotEmpty) {
      await sendMessage(
        chatId: preferredChatId,
        senderId: currentUserId,
        content: initialMessageContent,
        type: 'text',
      );
    }

    return preferredChatId;
  }

  Stream<List<ChatPreview>> watchUserChats({required String userId}) {
    final query = _firestore
        .collection(chatsCollection)
        .where('participants', arrayContains: userId);

    return query.snapshots().asyncMap((snapshot) async {
      final Map<String, ChatPreview> bestByPair = {};
      final Map<String, UserModel> userCache = {};
      for (final doc in snapshot.docs) {
        final data = doc.data();

        // Get last message from subcollection
        final lastMessageSnap = await doc.reference
            .collection(messagesSubcollection)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        Message? lastMessage;
        if (lastMessageSnap.docs.isNotEmpty) {
          final msgData = lastMessageSnap.docs.first.data();
          lastMessage = Message.fromJson(msgData);
        } else if ((data['lastMessage'] ?? '').toString().isNotEmpty) {
          // Fallback to summary stored on chat doc if present
          lastMessage = Message(
            senderId: data['lastSenderId'] ?? '',
            content: data['lastMessage'] ?? '',
            read: true,
            timestamp:
                (data['updatedAt'] as Timestamp?)?.toDate() ??
                DateTime.fromMillisecondsSinceEpoch(0),
            type: 'text',
          );
        }

        final createdAt =
            (data['createdAt'] as Timestamp?)?.toDate() ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final updatedAt =
            (data['updatedAt'] as Timestamp?)?.toDate() ??
            (data['lastTimestamp'] as Timestamp?)?.toDate() ??
            createdAt;

        final participants = List<String>.from(
          data['participants'] ?? const [],
        );
        final sortedParticipants = [...participants]..sort();
        final pairKey = sortedParticipants.join('_');

        // Get the other participant's ID
        final otherParticipantId = participants.firstWhere(
          (id) => id != userId,
          orElse: () => '',
        );

        // Fetch other participant's profile if not cached
        String otherParticipantName = '';
        String otherParticipantPhotoUrl = '';
        if (otherParticipantId.isNotEmpty) {
          if (!userCache.containsKey(otherParticipantId)) {
            final user = await _profileService.getUserById(otherParticipantId);
            if (user != null) {
              userCache[otherParticipantId] = user;
            }
          }
          final user = userCache[otherParticipantId];
          if (user != null) {
            otherParticipantName = user.name;
            otherParticipantPhotoUrl = user.photoUrl;
          }
        }

        final preview = ChatPreview(
          chatId: doc.id,
          bookId: data['bookId'] ?? '',
          participants: participants,
          lastMessage: lastMessage,
          createdAt: createdAt,
          updatedAt: updatedAt,
          bookTitle: data['bookTitle'] ?? '',
          bookAuthor: data['bookAuthor'] ?? '',
          otherParticipantName: otherParticipantName,
          otherParticipantPhotoUrl: otherParticipantPhotoUrl,
        );

        if (!bestByPair.containsKey(pairKey)) {
          bestByPair[pairKey] = preview;
        } else {
          final existing = bestByPair[pairKey]!;
          // Prefer the most recently updated chat. If equal, prefer the new deterministic id format.
          final isMoreRecent = preview.updatedAt.isAfter(existing.updatedAt);
          final isDeterministicId = doc.id == 'chat_$pairKey';
          if (isMoreRecent || isDeterministicId) {
            bestByPair[pairKey] = preview;
          }
        }
      }
      // Return the deduplicated chats sorted by updatedAt desc
      final result = bestByPair.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return result;
    });
  }

  Future<List<ChatPreview>> fetchUserChatsOnce({required String userId}) async {
    final query = _firestore
        .collection(chatsCollection)
        .where('participants', arrayContains: userId);

    final snapshot = await query.get(const GetOptions(source: Source.server));

    final Map<String, ChatPreview> bestByPair = {};
    final Map<String, UserModel> userCache = {};
    for (final doc in snapshot.docs) {
      final data = doc.data();

      // Get last message from subcollection
      final lastMessageSnap = await doc.reference
          .collection(messagesSubcollection)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      Message? lastMessage;
      if (lastMessageSnap.docs.isNotEmpty) {
        final msgData = lastMessageSnap.docs.first.data();
        lastMessage = Message.fromJson(msgData);
      } else if ((data['lastMessage'] ?? '').toString().isNotEmpty) {
        // Fallback to summary stored on chat doc if present
        lastMessage = Message(
          senderId: data['lastSenderId'] ?? '',
          content: data['lastMessage'] ?? '',
          read: true,
          timestamp:
              (data['updatedAt'] as Timestamp?)?.toDate() ??
              DateTime.fromMillisecondsSinceEpoch(0),
          type: 'text',
        );
      }

      final createdAt =
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final updatedAt =
          (data['updatedAt'] as Timestamp?)?.toDate() ??
          (data['lastTimestamp'] as Timestamp?)?.toDate() ??
          createdAt;

      final participants = List<String>.from(data['participants'] ?? const []);
      final sortedParticipants = [...participants]..sort();
      final pairKey = sortedParticipants.join('_');

      // Get the other participant's ID
      final otherParticipantId = participants.firstWhere(
        (id) => id != userId,
        orElse: () => '',
      );

      // Fetch other participant's profile if not cached
      String otherParticipantName = '';
      String otherParticipantPhotoUrl = '';
      if (otherParticipantId.isNotEmpty) {
        if (!userCache.containsKey(otherParticipantId)) {
          final user = await _profileService.getUserById(otherParticipantId);
          if (user != null) {
            userCache[otherParticipantId] = user;
          }
        }
        final user = userCache[otherParticipantId];
        if (user != null) {
          otherParticipantName = user.name;
          otherParticipantPhotoUrl = user.photoUrl;
        }
      }

      final preview = ChatPreview(
        chatId: doc.id,
        bookId: data['bookId'] ?? '',
        participants: participants,
        lastMessage: lastMessage,
        createdAt: createdAt,
        updatedAt: updatedAt,
        bookTitle: data['bookTitle'] ?? '',
        bookAuthor: data['bookAuthor'] ?? '',
        otherParticipantName: otherParticipantName,
        otherParticipantPhotoUrl: otherParticipantPhotoUrl,
      );

      if (!bestByPair.containsKey(pairKey)) {
        bestByPair[pairKey] = preview;
      } else {
        final existing = bestByPair[pairKey]!;
        final isMoreRecent = preview.updatedAt.isAfter(existing.updatedAt);
        final isDeterministicId = doc.id == 'chat_$pairKey';
        if (isMoreRecent || isDeterministicId) {
          bestByPair[pairKey] = preview;
        }
      }
    }

    final result = bestByPair.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return result;
  }

  /// Stream of chat messages as our domain model.
  Stream<List<Message>> watchMessages({required String chatId}) {
    return _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesSubcollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList(),
        );
  }

  /// Stream of chat messages directly as flutter_chat_types messages.
  Stream<List<types.Message>> watchMessagesAsTypes({
    required String chatId,
    required String currentUserId,
  }) {
    return _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesSubcollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final message = Message.fromJson(data);
            return _toTypesTextMessage(
              id: doc.id,
              message: message,
              currentUserId: currentUserId,
            );
          }).toList(),
        );
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String? type,
  }) async {
    final now = DateTime.now();
    final message = Message(
      senderId: senderId,
      content: content,
      read: false,
      timestamp: now,
      type: type ?? 'text',
    );

    final chatRef = _firestore.collection(chatsCollection).doc(chatId);
    await chatRef.collection(messagesSubcollection).add(message.toJson());

    // Update chat summary
    await chatRef.update({
      'lastMessage': content,
      'lastSenderId': senderId,
      'updatedAt': Timestamp.fromDate(now),
      'lastTimestamp': Timestamp.fromDate(now),
    });
  }

  Future<void> markAllAsRead({
    required String chatId,
    required String currentUserId,
  }) async {
    final query = await _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesSubcollection)
        .where('senderId', isNotEqualTo: currentUserId)
        .where('read', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  types.TextMessage _toTypesTextMessage({
    required String id,
    required Message message,
    required String currentUserId,
  }) {
    final author = types.User(id: message.senderId);
    return types.TextMessage(
      id: id,
      author: author,
      text: message.content,
      createdAt: message.timestamp.millisecondsSinceEpoch,
      status: message.read
          ? types.Status.seen
          : (message.senderId == currentUserId
                ? types.Status.sent
                : types.Status.delivered),
      metadata: {if (message.type != null) 'type': message.type},
    );
  }
}
