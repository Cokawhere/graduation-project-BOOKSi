import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/blog_controller.dart';
import '../models/blog_models.dart';
import '../../../common/styles/colors.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';

class BlogDetailsView extends StatelessWidget {
  final PostModel post;

  const BlogDetailsView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BlogController controller = Get.find<BlogController>();
    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.brown,
        title: const Text(
          'Post Details',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Delete
          Builder(
            builder: (context) {
              final currentUserId = controller.currentUserId;
              if (currentUserId == post.userId) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.white),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditDialog(context, controller);
                        break;
                      case 'delete':
                        _showDeleteDialog(context, controller);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Post content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: post.userPhotoUrl.isNotEmpty
                            ? NetworkImage(post.userPhotoUrl)
                            : null,
                        child: post.userPhotoUrl.isEmpty
                            ? const Icon(Icons.person, color: AppColors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _formatDate(post.createdAt),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.dark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content
                  Obx(() {
                    final isEditing =
                        controller.editingPosts[post.postId] ?? false;
                    if (isEditing) {
                      final editController =
                          controller.postEditControllers[post.postId];
                      if (editController != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: editController,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Edit your post...',
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.dark,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      controller.cancelPostEdit(post.postId),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () =>
                                      controller.savePostEdit(post.postId),
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    }
                    return Text(
                      post.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.dark,
                        height: 1.5,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    );
                  }),

                  // Image if exists
                  if (post.imageURL != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        post.imageURL!,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: AppColors.olive,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppColors.dark,
                              size: 80,
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => _buildActionButton(
                            icon: controller.isLikedByUser(post.postId)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            label: '${controller.getLikeCount(post.postId)}',
                            color: controller.isLikedByUser(post.postId)
                                ? Colors.red
                                : AppColors.dark,
                            onTap: () => controller.toggleLike(post.postId),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Obx(
                          () => _buildActionButton(
                            icon: Icons.comment_outlined,
                            label: '${controller.getCommentCount(post.postId)}',
                            color: AppColors.dark,
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Comments section
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Comments list
                  Obx(() {
                    final comments = controller.getCommentsForPost(post.postId);
                    if (comments.isNotEmpty) {
                      return Column(
                        children: comments
                            .map(
                              (commentMap) => _buildCommentCard(
                                commentMap['comment'] as CommentModel,
                                controller,
                                commentMap['id'] as String,
                              ),
                            )
                            .toList(),
                      );
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No comments yet. Be the first to comment!',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.dark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),

          // Add comment section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.brown),
                    ),
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final comment = commentController.text.trim();
                    if (comment.isNotEmpty) {
                      controller.addComment(post.postId, comment);
                      commentController.clear();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.brown,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(
    CommentModel comment,
    BlogController controller,
    String commentId,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: comment.userPhotoUrl.isNotEmpty
                      ? NetworkImage(comment.userPhotoUrl)
                      : null,
                  child: comment.userPhotoUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          color: AppColors.white,
                          size: 16,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatDate(comment.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.dark,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete button for comment owner
                Builder(
                  builder: (context) {
                    final currentUserId = controller.currentUserId;
                    if (currentUserId == comment.userId) {
                      return PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          size: 16,
                          color: AppColors.dark,
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              controller.startEditingComment(
                                commentId,
                                comment.content,
                              );
                              break;
                            case 'delete':
                              _showDeleteCommentDialog(commentId, controller);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Edit', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              final isEditingComment =
                  controller.editingComments[commentId] ?? false;
              if (isEditingComment) {
                final editController =
                    controller.commentEditControllers[commentId];
                if (editController != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: editController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Edit your comment...',
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.dark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                controller.cancelCommentEdit(commentId),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => controller.saveCommentEdit(
                              post.postId,
                              commentId,
                              comment,
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }
              return Text(
                comment.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.dark,
                  height: 1.3,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, BlogController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deletePost(post.postId);
              Get.back();
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, BlogController controller) {
    controller.startEditingPost(post.postId, post.content);
  }

  void _showDeleteCommentDialog(String commentId, BlogController controller) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteComment(post.postId, commentId);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
