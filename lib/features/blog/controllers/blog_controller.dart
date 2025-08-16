import 'package:get/get.dart';
import '../models/blog_models.dart';
import '../services/blog_services.dart';
import '../../profile/services/profile_service.dart';
import '../../profile/models/profile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class BlogController extends GetxController {
  final BlogService _blogService = BlogService();
  final BlogImageKitService _imageKitService = BlogImageKitService();
  final FirebaseService _firebaseService = FirebaseService();
  final ImagePicker _picker = ImagePicker();

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxString selectedImagePath = ''.obs;
  final RxString selectedImageUrl = ''.obs;

  // Store likes and comments for each post
  final RxMap<String, List<String>> postLikes = <String, List<String>>{}.obs;
  final RxMap<String, List<Map<String, dynamic>>> postComments =
      <String, List<Map<String, dynamic>>>{}.obs;
  final RxMap<String, bool> userLikedPosts = <String, bool>{}.obs;

  // Cache of user profiles keyed by userId for displaying name/photo
  final RxMap<String, UserModel> userProfiles = <String, UserModel>{}.obs;

  // Editing state
  final RxMap<String, bool> editingPosts = <String, bool>{}.obs;
  final RxMap<String, bool> editingComments = <String, bool>{}.obs;
  final RxMap<String, TextEditingController> postEditControllers =
      <String, TextEditingController>{}.obs;
  final RxMap<String, TextEditingController> commentEditControllers =
      <String, TextEditingController>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  // Load all posts
  void loadPosts() {
    _blogService.getAllPosts().listen(
      (postsList) {
        posts.value = postsList;

        // Load likes and comments for each post
        for (var post in postsList) {
          loadLikesForPost(post.postId);
          loadCommentsForPost(post.postId);
        }

        // Preload user profiles for all unique authors
        final uniqueUserIds = postsList.map((p) => p.userId).toSet();
        for (final userId in uniqueUserIds) {
          loadUserProfile(userId);
        }
      },
      onError: (error) {
        // Try alternative collection names
        _blogService.getAllPostsFromCollection('blog').listen((postsList) {
          posts.value = postsList;
          final uniqueUserIds = postsList.map((p) => p.userId).toSet();
          for (final userId in uniqueUserIds) {
            loadUserProfile(userId);
          }
        });
      },
    );
  }

  // Load likes for a specific post
  void loadLikesForPost(String postId) {
    _blogService.getLikesForPost(postId).listen((likeIds) {
      postLikes[postId] = likeIds;

      // Update user liked status
      final currentUserId = _blogService.currentUserId;
      if (currentUserId != null) {
        userLikedPosts[postId] = likeIds.contains(currentUserId);
      }
    });
  }

  // Load comments for a specific post
  void loadCommentsForPost(String postId) {
    _blogService.getCommentsForPost(postId).listen((comments) {
      postComments[postId] = comments;
    });
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  // Upload image and get URL
  Future<String?> uploadImageAndGetUrl() async {
    if (selectedImagePath.value.isEmpty) return null;

    try {
      isUploading.value = true;
      final imageFile = File(selectedImagePath.value);
      final imageData = await _imageKitService.uploadImage(imageFile);

      if (imageData != null) {
        selectedImageUrl.value = imageData['url'];
        return imageData['url'];
      }
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      isUploading.value = false;
    }
    return null;
  }

  // Create new post
  Future<void> createPost(String content) async {
    try {
      isLoading.value = true;

      String? imageUrl;
      if (selectedImagePath.value.isNotEmpty) {
        imageUrl = await uploadImageAndGetUrl();
      }

      final currentUser = await _getCurrentUser();
      if (currentUser == null) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      final post = PostModel(
        postId: _generatePostId(),
        userId: currentUser.uid,
        content: content,
        imageURL: imageUrl,
        createdAt: DateTime.now(),
      );

      await _blogService.createPost(post);

      // Clear form
      selectedImagePath.value = '';
      selectedImageUrl.value = '';

      Get.snackbar('Success', 'Post created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Like/Unlike post
  Future<void> toggleLike(String postId) async {
    final currentUserId = _blogService.currentUserId;
    if (currentUserId == null) return;

    try {
      await _blogService.toggleLike(postId, currentUserId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle like: $e');
    }
  }

  // Add comment
  Future<void> addComment(String postId, String content) async {
    try {
      final currentUser = await _getCurrentUser();
      if (currentUser == null) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      final comment = CommentModel(
        userId: currentUser.uid,
        content: content,
        createdAt: DateTime.now(),
        userName: currentUser.name,
        userPhotoUrl: currentUser.photoUrl,
      );

      await _blogService.addComment(postId, comment);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add comment: $e');
    }
  }

  // Delete comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _blogService.deleteComment(postId, commentId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete comment: $e');
    }
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    try {
      await _blogService.deletePost(postId);
      Get.snackbar('Success', 'Post deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post: $e');
    }
  }

  // Start editing post
  void startEditingPost(String postId, String currentContent) {
    editingPosts[postId] = true;
    postEditControllers[postId] = TextEditingController(text: currentContent);
  }

  // Save post edit
  Future<void> savePostEdit(String postId) async {
    try {
      final controller = postEditControllers[postId];
      if (controller == null) return;

      final newContent = controller.text.trim();
      if (newContent.isEmpty) {
        Get.snackbar('Error', 'Post content cannot be empty');
        return;
      }

      final post = posts.firstWhere((p) => p.postId == postId);
      final updatedPost = post.copyWith(content: newContent);

      await _blogService.updatePost(updatedPost);

      // Clear editing state
      editingPosts[postId] = false;
      postEditControllers[postId]?.dispose();
      postEditControllers.remove(postId);

      Get.snackbar('Success', 'Post updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update post: $e');
    }
  }

  // Cancel post edit
  void cancelPostEdit(String postId) {
    editingPosts[postId] = false;
    postEditControllers[postId]?.dispose();
    postEditControllers.remove(postId);
  }

  // Start editing comment
  void startEditingComment(String commentId, String currentContent) {
    editingComments[commentId] = true;
    commentEditControllers[commentId] = TextEditingController(
      text: currentContent,
    );
  }

  // Save comment edit
  Future<void> saveCommentEdit(
    String postId,
    String commentId,
    CommentModel originalComment,
  ) async {
    try {
      final controller = commentEditControllers[commentId];
      if (controller == null) return;

      final newContent = controller.text.trim();
      if (newContent.isEmpty) {
        Get.snackbar('Error', 'Comment content cannot be empty');
        return;
      }

      final updatedComment = originalComment.copyWith(content: newContent);
      await _blogService.updateComment(postId, commentId, updatedComment);

      // Clear editing state
      editingComments[commentId] = false;
      commentEditControllers[commentId]?.dispose();
      commentEditControllers.remove(commentId);

      Get.snackbar('Success', 'Comment updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update comment: $e');
    }
  }

  // Cancel comment edit
  void cancelCommentEdit(String commentId) {
    editingComments[commentId] = false;
    commentEditControllers[commentId]?.dispose();
    commentEditControllers.remove(commentId);
  }

  // Check if user liked the post
  bool isLikedByUser(String postId) {
    return userLikedPosts[postId] ?? false;
  }

  // Get like count
  int getLikeCount(String postId) {
    return postLikes[postId]?.length ?? 0;
  }

  // Get comment count
  int getCommentCount(String postId) {
    return postComments[postId]?.length ?? 0;
  }

  // Get likes for a post (returns list of user IDs)
  List<String> getLikesForPost(String postId) {
    return postLikes[postId] ?? [];
  }

  // Get comments for a post
  List<Map<String, dynamic>> getCommentsForPost(String postId) {
    return postComments[postId] ?? [];
  }

  // Generate unique post ID
  String _generatePostId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Get current user ID
  String? get currentUserId => _blogService.currentUserId;

  // Get current user from profile service
  Future<UserModel?> _getCurrentUser() async {
    return await _firebaseService.getCurrentUser();
  }

  // Load a user's profile (name, photoUrl) if not already cached
  Future<void> loadUserProfile(String userId) async {
    if (userProfiles.containsKey(userId)) return;
    try {
      final user = await _firebaseService.getUserById(userId);
      if (user != null) {
        userProfiles[userId] = user;
      }
    } catch (_) {}
  }

  // Helpers to access cached user data for UI
  String getUserName(String userId) {
    return userProfiles[userId]?.name ?? 'User';
  }

  String? getUserPhotoUrl(String userId) {
    return userProfiles[userId]?.photoUrl;
  }

  // Clear selected image
  void clearSelectedImage() {
    selectedImagePath.value = '';
    selectedImageUrl.value = '';
  }

  @override
  void onClose() {
    // Dispose all text editing controllers
    for (var controller in postEditControllers.values) {
      controller.dispose();
    }
    for (var controller in commentEditControllers.values) {
      controller.dispose();
    }
    postEditControllers.clear();
    commentEditControllers.clear();
    super.onClose();
  }
}
