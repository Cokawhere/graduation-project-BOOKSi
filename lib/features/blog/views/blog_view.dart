import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_bottom_navigation.dart';
import '../../Home/home_view.dart';
import '../controllers/blog_controller.dart';
import '../models/blog_models.dart';
import '../../../common/styles/colors.dart';
import 'add_blog_view.dart';
import 'blog_details_view.dart';

class BlogView extends StatelessWidget {
  BlogView({super.key});

  final BlogController controller = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        toolbarHeight: 70,
        actions: [
          TextButton(
            onPressed: controller.isLoading.value
                ? null
                : () => Get.to(() => AddBlogView()),
            child: Text(
              'add_blog'.tr,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.brown,
        title: Text(
          'blog'.tr,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 30),
          onPressed: () => Get.off(HomeView()),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.brown),
                SizedBox(height: 16),
                Text(
                  'loading_posts'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 16),
                Text(
                  'no_posts_yet'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.dark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'be_first_to_share'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.loadPosts();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return BlogPostCard(
                post: post,
                controller: controller,
                onTap: () => Get.to(() => BlogDetailsView(post: post)),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class BlogPostCard extends StatelessWidget {
  final PostModel post;
  final BlogController controller;
  final VoidCallback onTap;

  const BlogPostCard({
    super.key,
    required this.post,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              Row(
                children: [
                  Obx(() {
                    final photoUrl = controller.getUserPhotoUrl(post.userId);
                    final hasPhoto = (photoUrl != null && photoUrl.isNotEmpty);
                    return CircleAvatar(
                      radius: 20,
                      backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
                      child: !hasPhoto
                          ? const Icon(Icons.person, color: AppColors.white)
                          : null,
                    );
                  }),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              controller.getUserName(post.userId),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )),
                        Text(
                          _formatDate(post.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Edit and delete buttons for post owner
                  Builder(
                    builder: (context) {
                      final currentUserId = controller.currentUserId;
                      if (currentUserId == post.userId) {
                        return PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                controller.startEditingPost(
                                  post.postId,
                                  post.content,
                                );
                                break;
                              case 'delete':
                                _showDeleteDialog(context, controller, post);
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
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
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
              const SizedBox(height: 12),

              // Content
              Obx(() {
                final isEditing = controller.editingPosts[post.postId] ?? false;
                if (isEditing) {
                  final editController =
                      controller.postEditControllers[post.postId];
                  if (editController != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: editController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Edit your post...',
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  controller.cancelPostEdit(post.postId),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () =>
                                  controller.savePostEdit(post.postId),
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
                  post.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                );
              }),

              // Image if exists
              if (post.imageURL != null && post.imageURL!.isNotEmpty) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imageURL!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.olive,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          color: Theme.of(context).colorScheme.primary,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Action buttons
              Row(
                children: [
                  Obx(
                    () => _buildActionButton(
                      icon: controller.isLikedByUser(post.postId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: '${controller.getLikeCount(post.postId)}',
                      color: controller.isLikedByUser(post.postId)
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      onTap: () => controller.toggleLike(post.postId),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Obx(
                    () => _buildActionButton(
                      icon: Icons.comment_outlined,
                      label: '${controller.getCommentCount(post.postId)}',
                      color: Theme.of(context).colorScheme.primary,
                      onTap: onTap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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

  void _showDeleteDialog(
    BuildContext context,
    BlogController controller,
    PostModel post,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deletePost(post.postId);
              Get.back();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
