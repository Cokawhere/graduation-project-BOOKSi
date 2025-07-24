import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../profile/services/profile_service.dart';
import '../../profile/models/profile.dart';

class ImageKitController extends GetxController {
  final ImageKitService _imageKitService = ImageKitService();
  final FirebaseService _firebaseService = FirebaseService();
  final RxBool isUploading = false.obs;
  final RxString imageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  /// ✅ Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// ✅ Upload book image and save book to Firestore
  Future<void> uploadBookImageAndSave(Book book, File imageFile) async {
    try {
      isUploading.value = true;
      final imageData = await _imageKitService.uploadImage(imageFile);
      if (imageData != null) {
        final updatedBook = book.copyWith(
          coverImage: imageData['url'],
          imageFileId: imageData['fileId'],
        );
        await _firebaseService.createBook(updatedBook);
      }
    } finally {
      isUploading.value = false;
    }
  }

  /// ✅ Update book image
  Future<void> updateBookImage(Book book, File newImage) async {
    try {
      isUploading.value = true;
      if (book.imageFileId != null) {
        await _imageKitService.deleteImage(book.imageFileId!);
      }
      final imageData = await _imageKitService.uploadImage(newImage);
      if (imageData != null) {
        final updatedBook = book.copyWith(
          coverImage: imageData['url'],
          imageFileId: imageData['fileId'],
        );
        await _firebaseService.updateBook(updatedBook);
      }
    } finally {
      isUploading.value = false;
    }
  }

  /// ✅ Delete book and its image
  Future<void> deleteBookWithImage(String bookId, String? imageFileId) async {
    if (imageFileId != null) {
      await _imageKitService.deleteImage(imageFileId);
    }
    await _firebaseService.deleteBook(bookId);
  }

  /// ✅ Upload user profile image
  Future<void> uploadUserProfileImage(UserModel user, File imageFile) async {
    try {
      isUploading.value = true;
      final imageData = await _imageKitService.uploadImage(imageFile);
      if (imageData != null) {
        final updatedUser = user.copyWith(
          photoUrl: imageData['url'],
          imageFileId: imageData['fileId'],
        );
        await _firebaseService.updateUser(updatedUser);
      }
    } finally {
      isUploading.value = false;
    }
  }

  /// ✅ Delete user profile image
  Future<void> deleteUserProfileImage(UserModel user) async {
    try {
      isUploading.value = true;
      if (user.imageFileId != null) {
        await _imageKitService.deleteImage(user.imageFileId!);
        final updatedUser = user.copyWith(photoUrl: '', imageFileId: null);
        await _firebaseService.updateUser(updatedUser);
      }
    } finally {
      isUploading.value = false;
    }
  }

Future<String?> uploadImageAndGetUrl(File imageFile) async {
  final imageData = await _imageKitService.uploadImage(imageFile);
  if (imageData != null) {
    return imageData['url'];
  }
  return null;
}

}
