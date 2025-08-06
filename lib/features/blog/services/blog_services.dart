import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/blog_models.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class BlogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Create a new post
  Future<void> createPost(PostModel post) async {
    await _firestore.collection('posts').doc(post.postId).set(post.toJson());
  }

  // Get all posts
  Stream<List<PostModel>> getAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((query) {
          final posts = query.docs.map((doc) {
            // Add the document ID to the data if postId is not present
            final data = Map<String, dynamic>.from(doc.data());
            if (!data.containsKey('postId')) {
              data['postId'] = doc.id;
            }

            return PostModel.fromJson(data);
          }).toList();
          return posts;
        });
  }

  // Alternative method to get posts from different collection names
  Stream<List<PostModel>> getAllPostsFromCollection(String collectionName) {
    return _firestore
        .collection(collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((query) {
          final posts = query.docs.map((doc) {
            // Add the document ID to the data if postId is not present
            final data = Map<String, dynamic>.from(doc.data());
            if (!data.containsKey('postId')) {
              data['postId'] = doc.id;
            }

            return PostModel.fromJson(data);
          }).toList();
          return posts;
        });
  }

  // Get post by ID
  Future<PostModel?> getPostById(String postId) async {
    final doc = await _firestore.collection('posts').doc(postId).get();
    if (doc.exists) {
      return PostModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Update post
  Future<void> updatePost(PostModel post) async {
    final updatedPost = post.copyWith(updatedAt: DateTime.now());
    await _firestore
        .collection('posts')
        .doc(post.postId)
        .update(updatedPost.toJson());
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    // Delete the post (likes are part of the post document, so they'll be deleted automatically)
    await _firestore.collection('posts').doc(postId).delete();

    // Delete all comments for this post (comments are still in subcollection)
    final commentsSnapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get();

    for (var doc in commentsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Like
  Future<void> toggleLike(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);

    // Get current post data
    final postDoc = await postRef.get();
    if (!postDoc.exists) return;

    final postData = postDoc.data()!;
    List<String> currentLikes = List<String>.from(postData['likes'] ?? []);

    if (currentLikes.contains(userId)) {
      currentLikes.remove(userId);
    } else {
      currentLikes.add(userId);
    }

    // Update the post document with new likes array
    await postRef.update({'likes': currentLikes});
  }

  // Get likes for a post (returns list of user IDs from post document)
  Stream<List<String>> getLikesForPost(String postId) {
    return _firestore.collection('posts').doc(postId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        return List<String>.from(data['likes'] ?? []);
      }
      return <String>[];
    });
  }

  // Check if user liked the post
  Future<bool> isLikedByUser(String postId, String userId) async {
    final postDoc = await _firestore.collection('posts').doc(postId).get();
    if (postDoc.exists) {
      final data = postDoc.data()!;
      final likes = List<String>.from(data['likes'] ?? []);
      return likes.contains(userId);
    }
    return false;
  }

  // Add comment to post
  Future<void> addComment(String postId, CommentModel comment) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(comment.toJson());
  }

  // Get comments for a post
  Stream<List<Map<String, dynamic>>> getCommentsForPost(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (query) => query.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  'comment': CommentModel.fromJson(doc.data()),
                },
              )
              .toList(),
        );
  }

  // Update comment
  Future<void> updateComment(
    String postId,
    String commentId,
    CommentModel comment,
  ) async {
    final updatedComment = comment.copyWith(updatedAt: DateTime.now());
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update(updatedComment.toJson());
  }

  // Delete comment
  Future<void> deleteComment(String postId, String commentId) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  // Get posts by user
  Stream<List<PostModel>> getPostsByUser(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (query) =>
              query.docs.map((doc) => PostModel.fromJson(doc.data())).toList(),
        );
  }
}

class BlogImageKitService {
  final String uploadUrl = 'https://upload.imagekit.io/api/v1/files/upload';
  final String publicKey = 'public_MaCFmiSUHRma6JalHM2Ux4ECbMw=';
  final String privateKey = 'private_QmWggbSNu+9ZAq8j/iYQHtu0k0g=';
  final String folder = '/blog';

  Future<Map<String, dynamic>?> uploadImage(File imageFile) async {
    final base64Image = base64Encode(await imageFile.readAsBytes());
    final fileName = basename(imageFile.path);

    final response = await http.post(
      Uri.parse(uploadUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$privateKey:'))}',
      },
      body: {
        'file': 'data:image/jpeg;base64,$base64Image',
        'fileName': fileName,
        'folder': folder,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'url': data['url'], 'fileId': data['fileId']};
    } else {
      print("ImageKit upload failed: ${response.body}");
      return null;
    }
  }

  Future<void> deleteImage(String fileId) async {
    final deleteUrl = 'https://api.imagekit.io/v1/files/$fileId';

    final response = await http.delete(
      Uri.parse(deleteUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$privateKey:'))}',
      },
    );

    if (response.statusCode == 204) {
      print("Image deleted from ImageKit");
    } else {
      print("Failed to delete image: ${response.body}");
    }
  }
}
