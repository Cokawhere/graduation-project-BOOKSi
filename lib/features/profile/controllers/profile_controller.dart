import 'package:booksi/features/profile/models/profile.dart';
import 'package:booksi/features/profile/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    isLoading.value = true;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    user.value = await _firebaseService.getUserById(uid);
    isLoading.value = false;
  }

  Future<void> updateUser(UserModel updatedUser) async {
    await _firebaseService.updateUser(updatedUser);
    user.value = updatedUser;
  }
}

class ImageUploadController extends GetxController {
  final ImageKitService _imageKitService = ImageKitService();
  final FirebaseService _firebaseService = FirebaseService();

  final RxBool isUploading = false.obs;



  
}


