import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/blog_controller.dart';
import '../../../common/styles/colors.dart';
import '../../../common/widgets/custom_button.dart';

class AddBlogView extends StatelessWidget {
  AddBlogView({super.key});

  final BlogController controller = Get.find<BlogController>();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.brown,
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => _createPost(),
              child: Text(
                'Post',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image picker section
            Obx(() => _buildImageSection()),
            const SizedBox(height: 16),

            // Content text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.brown),
                ),
                child: TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    hintText: 'Share your book experience...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  maxLines: null,
                  expands: true,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Add Photo',
                    onPressed: _showImagePickerDialog,
                    backgroundColor: AppColors.olive,
                    textColor: AppColors.dark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Camera',
                    onPressed: () => controller.pickImageFromCamera(),
                    backgroundColor: AppColors.teaMilk,
                    textColor: AppColors.dark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (controller.selectedImagePath.value.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.olive,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dark.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 50,
              color: AppColors.dark.withOpacity(0.6),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a photo to your post',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.dark.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(controller.selectedImagePath.value),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: controller.clearSelectedImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: AppColors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dark.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.brown),
              title: const Text('Choose from Gallery'),
              onTap: () {
                controller.pickImageFromGallery();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.brown),
              title: const Text('Take a Photo'),
              onTap: () {
                controller.pickImageFromCamera();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createPost() {
    final content = contentController.text.trim();
    if (content.isEmpty) {
      Get.snackbar(
        'Error',
        'Please write something to share',
        backgroundColor: Colors.red,
        colorText: AppColors.white,
      );
      return;
    }

    controller.createPost(content);
    contentController.clear();
    Get.back();
  }
}
