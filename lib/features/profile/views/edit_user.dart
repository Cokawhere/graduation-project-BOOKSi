import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booksi/features/profile/controllers/profile_controller.dart';
import 'package:booksi/features/profile/models/profile.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/styles/colors.dart';
import '../controllers/imagekit_controller.dart';
import 'dart:io';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  final List<String> genres = [
    "Fiction",
    "Fantasy",
    "Science Fiction",
    "Mystery & Thriller",
    "Romance",
    "Historical",
    "Young Adult",
    "Horror",
    "Biography",
    "Personal Growth",
  ];

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _addressController;
  final ProfileController _profileController = Get.find<ProfileController>();
  final ImageKitController _imageKitController = Get.put(ImageKitController());

  List<String> _selectedGenres = [];
  File? _profileImage;
  bool _isUploading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final user = _profileController.user.value;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _selectedGenres = List<String>.from(user?.genres ?? []);
  }

  void _pickProfileImage() async {
    final picked = await _imageKitController.pickImageFromGallery();
    if (picked != null) {
      setState(() {
        _profileImage = picked;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGenres.isEmpty) {
      setState(() {
        _errorText = 'select_genre'.tr;
      });
      return;
    }
    setState(() {
      _isUploading = true;
      _errorText = null;
    });
    final user = _profileController.user.value;
    try {
      var updatedUser = user!.copyWith(
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        address: _addressController.text.trim(),
        genres: _selectedGenres,
        updatedAt: DateTime.now(),
      );
      if (_profileImage != null) {
        await _imageKitController.uploadUserProfileImage(
          updatedUser,
          _profileImage!,
        );
        await _profileController.loadUser();
      } else {
        await _profileController.updateUser(updatedUser);
      }
      Get.back();
      Get.snackbar('success'.tr, 'profile_updated'.tr);
    } catch (e) {
      setState(() {
        _errorText = '${'update_failed'.tr}: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_profile'.tr),
        backgroundColor: AppColors.brown,
        foregroundColor: AppColors.white,
      ),
      body: Obx(() {
        final user = _profileController.user.value;
        if (_profileController.isLoading.value || user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              media.size.width * 0.04,
              media.size.height * 0.03,
              media.size.width * 0.04,
              media.size.height * 0.03 + 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: media.size.width * 0.15,
                          backgroundColor: AppColors.olive,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : (user.photoUrl.isNotEmpty
                                    ? NetworkImage(user.photoUrl)
                                          as ImageProvider
                                    : null),
                          child:
                              (user.photoUrl.isEmpty && _profileImage == null)
                              ? Icon(
                                  Icons.person,
                                  size: media.size.width * 0.15,
                                  color: AppColors.brown,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CustomButton(
                            padding: const EdgeInsets.all(8),
                            borderRadius: 30,
                            backgroundColor: AppColors.orange,
                            text: '',
                            prefixIcon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _pickProfileImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.size.height * 0.03),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'name'.tr,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'required'.tr : null,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'email'.tr,
                    isEnabled: false,
                  ),
                  CustomTextField(
                    controller: _bioController,
                    hintText: 'bio'.tr,
                    textStyle: const TextStyle(),
                  ),
                  CustomTextField(
                    controller: _addressController,
                    hintText: 'address'.tr,
                  ),
                  SizedBox(height: media.size.height * 0.015),
                  Text(
                    'genres'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: media.size.width * 0.04,
                    ),
                  ),
                  ...genres.map(
                    (g) => CheckboxListTile(
                      value: _selectedGenres.contains(g),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedGenres.add(g);
                          } else {
                            _selectedGenres.remove(g);
                          }
                        });
                      },
                      title: Text(g.tr),
                      activeColor: AppColors.orange,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  if (_errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: media.size.height * 0.03),
                  CustomButton(
                    text: 'save'.tr,
                    onPressed: _isUploading ? null : _submit,
                    isLoading: _isUploading,
                    backgroundColor: AppColors.brown,
                    textColor: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
