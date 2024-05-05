
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixcomputer/src/help/show_message.dart';
import 'package:sixcomputer/src/model/product_category_model.dart';
import 'package:sixcomputer/src/repo/product_categories_repo.dart';
import 'package:sixcomputer/src/repo/upload_file.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ProductCategoryAddView extends StatefulWidget {
  const ProductCategoryAddView({super.key});

  static const String routeName = '/product_category_add';

  @override
  State<ProductCategoryAddView> createState() => _ProductCategoryAddViewState();
}

class _ProductCategoryAddViewState extends State<ProductCategoryAddView> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  var uuid = const Uuid();

  String avatar = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Material(
                shadowColor: Colors.black,
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                child: TextFormField(
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product category name';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter product category name',
                    fillColor: const Color.fromARGB(255, 126, 126, 126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Material(
                  // shadowColor: Colors.black,
                  // elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Avatar',
                          style: TextStyle(fontSize: 14.0),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () async {
                            selectAvatar();
                          },
                          child: Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 126, 126, 126),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: avatar.isEmpty
                                ? const Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 40.0,
                                    ),
                                  )
                                : Image.file(
                                    File(avatar),
                                    height: 100.0,
                                    width: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        )
                      ]),
                ),

              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add product category
                  addProductCategory();
                },
                child: const Text('Add Product Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addProductCategory() async {
    final ProductCategoriesClient productCategoriesClient = ProductCategoriesClient();

    UploadFileClient uploadFileClient = UploadFileClient();

    // Upload avatar

    if (avatar.isNotEmpty) {
      final path =
          'category/${avatar.split('/')[avatar.split('/').length - 1]}';
      final String avatarUrl = await uploadFileClient.uploadFileByPath(avatar, path);
      avatar = avatarUrl;
    }
    // Add product category
    final ProductCategoryModel productCategory = ProductCategoryModel(
      categoryName: nameController.text,
      categoryId: const Uuid().v4(),
      categoryImage: avatar
    );

    // final List<ProductCategoryModel> productCategories = await productCategoriesClient.fetchProductCategories();

    // Add product category to the database
    await productCategoriesClient.addProductCategory(productCategory);

    // ignore: use_build_context_synchronously
    Message.showToast(context, 'Product category added successfully');

    // navigate to product category list view
    Navigator.pop(context);
  }

  selectAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      avatar = pickedFile.path;
      setState(() {});
    }
  }
}