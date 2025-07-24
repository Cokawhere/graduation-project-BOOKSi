import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/styles/colors.dart';
import '../controllers/book_controllers.dart';
import '../controllers/imagekit_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/profile.dart';
import 'package:uuid/uuid.dart';

class AddBookView extends StatefulWidget {
  const AddBookView({Key? key}) : super(key: key);

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();

  final BookController _bookController = Get.put(BookController());
  final ImageKitController _imageKitController = Get.put(ImageKitController());
  final ProfileController _profileController = Get.put(ProfileController());

  String? _selectedGenre;
  String _condition = 'New';
  List<String> _availableFor = [];
  File? _coverImage;
  bool _isUploading = false;

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

  void _pickCoverImage() async {
    final picked = await _imageKitController.pickImageFromGallery();
    if (picked != null) {
      setState(() {
        _coverImage = picked;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGenre == null) {
      Get.snackbar('Error', 'Please select a genre');
      return;
    }
    if (_availableFor.isEmpty) {
      Get.snackbar('Error', 'Please select at least one availability option');
      return;
    }
    if (_coverImage == null) {
      Get.snackbar('Error', 'Please upload a cover image');
      return;
    }
    setState(() {
      _isUploading = true;
    });
    final user = _profileController.user.value;
    String? location = _locationController.text.trim();
    if ((user?.address == null || user!.address!.isEmpty) && location.isEmpty) {
      Get.snackbar('Error', 'Please enter your location');
      setState(() {
        _isUploading = false;
      });
      return;
    }
    if (user?.address == null || user!.address!.isEmpty) {
    } else {
      location = user.address;
    }
    double? price;
    if (_availableFor.contains('Sale')) {
      if (_priceController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter a price for sale');
        setState(() {
          _isUploading = false;
        });
        return;
      }
      price = double.tryParse(_priceController.text.trim());
      if (price == null) {
        Get.snackbar('Error', 'Invalid price');
        setState(() {
          _isUploading = false;
        });
        return;
      }
    }
    final book = Book(
      id: Uuid().v4(),
      ownerId: user?.uid ?? '',
      ownerType: 'user',
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      isbn: '',
      genre: _selectedGenre!,
      averageRating: 0.0,
      totalRatings: 0,
      description: _descriptionController.text.trim(),
      condition: _condition,
      availableFor: _availableFor,
      approval: 'pending',
      isDeleted: false,
      status: 'available',
      coverImage: '',
      images: [],
      location: location,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      price: price,
      imageFileId: null,
    );
    await _imageKitController.uploadBookImageAndSave(book, _coverImage!);
    setState(() {
      _isUploading = false;
    });
    Get.back();
    Get.snackbar('Success', 'Book added and pending approval');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double horizontalPadding = media.size.width * 0.04;
    final double verticalPadding = media.size.height * 0.03;
    final user = _profileController.user.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('add_book'.tr),
        backgroundColor: AppColors.brown,
        foregroundColor: AppColors.white,
      ),
      resizeToAvoidBottomInset: true,
      body: Obx(
        () => _isUploading || _imageKitController.isUploading.value
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    verticalPadding,
                    horizontalPadding,
                    verticalPadding + 16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: _titleController,
                          hintText:
                              'book_name'.tr,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'enter_book_name'.tr
                              : null,
                        ),
                        CustomTextField(
                          controller: _authorController,
                          hintText: 'author_name'.tr,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'enter_author_name'.tr
                              : null,
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedGenre,
                          items: genres
                              .map(
                                (g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g.tr),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedGenre = val),
                          decoration: InputDecoration(
                            labelText: 'genre'.tr, 
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          validator: (v) => v == null
                              ? 'select_genre'.tr
                              : null, 
                        ),
                        CustomTextField(
                          controller: _descriptionController,
                          hintText: 'description'.tr, 
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'enter_description'.tr
                              : null,
                        ),
                        SizedBox(height: media.size.height * 0.015),
                        Text(
                          'condition'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: media.size.width * 0.04,
                          ),
                        ), 
                        Row(
                          children: [
                            Radio<String>(
                              value: 'New',
                              groupValue: _condition,
                              onChanged: (val) =>
                                  setState(() => _condition = val!),
                              activeColor: AppColors.orange,
                            ),
                            Text('new'.tr), 
                            Radio<String>(
                              value: 'Used',
                              groupValue: _condition,
                              onChanged: (val) =>
                                  setState(() => _condition = val!),
                              activeColor: AppColors.orange,
                            ),
                            Text('used'.tr),
                          ],
                        ),
                        SizedBox(height: media.size.height * 0.015),
                        Text(
                          'available_for'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: media.size.width * 0.04,
                          ),
                        ), 
                        CheckboxListTile(
                          value: _availableFor.contains('Sale'),
                          onChanged: (val) => setState(() {
                            if (val == true) {
                              _availableFor.add('Sale');
                            } else {
                              _availableFor.remove('Sale');
                            }
                          }),
                          title: Text('sale'.tr), 
                          activeColor: AppColors.orange,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          value: _availableFor.contains('Trade'),
                          onChanged: (val) => setState(() {
                            if (val == true) {
                              _availableFor.add('Trade');
                            } else {
                              _availableFor.remove('Trade');
                            }
                          }),
                          title: Text('trade'.tr), 
                          activeColor: AppColors.orange,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        if (_availableFor.contains('Sale'))
                          CustomTextField(
                            controller: _priceController,
                            hintText: 'price'.tr,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (!_availableFor.contains('Sale')) return null;
                              if (v == null || v.trim().isEmpty)
                                return 'enter_price'.tr; 
                              if (double.tryParse(v.trim()) == null)
                                return 'invalid_price'.tr; 
                              return null;
                            },
                          ),
                        SizedBox(height: media.size.height * 0.015),
                        Text(
                          'cover_image'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: media.size.width * 0.04,
                          ),
                        ), 
                        SizedBox(height: media.size.height * 0.01),
                        _coverImage == null
                            ? CustomButton(
                                text: 'upload_cover_image'.tr,
                                onPressed: _pickCoverImage,
                                backgroundColor: AppColors.orange,
                              )
                            : Column(
                                children: [
                                  Image.file(
                                    _coverImage!,
                                    height: media.size.height * 0.18,
                                  ),
                                  CustomButton(
                                    text: 'change_image'.tr,
                                    onPressed: _pickCoverImage,
                                    backgroundColor: AppColors.orange,
                                  ),
                                ],
                              ),
                        SizedBox(height: media.size.height * 0.015),
                        if (user?.address == null || user!.address!.isEmpty)
                          CustomTextField(
                            controller: _locationController,
                            hintText: 'location'.tr, 
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'enter_location'.tr
                                : null, 
                          ),
                        SizedBox(height: media.size.height * 0.03),
                        CustomButton(
                          text: 'add_book'.tr, 
                          onPressed: _isUploading ? null : _submit,
                          isLoading: _isUploading,
                          backgroundColor: AppColors.brown,
                          textColor: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
