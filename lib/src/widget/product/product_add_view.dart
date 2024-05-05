import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sixcomputer/src/help/show_message.dart';
import 'package:sixcomputer/src/model/product_category_model.dart';
import 'package:sixcomputer/src/model/product_model.dart';
import 'package:sixcomputer/src/repo/product_categories_repo.dart';
import 'package:sixcomputer/src/repo/product_repo.dart';
import 'package:sixcomputer/src/repo/upload_file.dart';
import 'package:uuid/uuid.dart';

class ProductAddView extends StatefulWidget {
  const ProductAddView({super.key});

  static const String routeName = '/add-product';

  @override
  State<ProductAddView> createState() => _ProductAddViewState();
}

class _ProductAddViewState extends State<ProductAddView> {
  final _formKey = GlobalKey<FormState>();

  final List<ProductCategoryModel> productCategories = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController sellingStatusController = TextEditingController();
  String categoryValue = '';

  String avatar = '';
  List<String> images = [];

  final listStatus = [
    {'id': 1, 'name': 'Active'},
    {'id': 0, 'name': 'Inactive'}
  ];

  final listSellingStatus = [
    {'id': 1, 'name': 'Selling'},
    {'id': 0, 'name': 'Not Selling'}
  ];

  getProductCategories() {
    ProductCategoriesClient().fetchProductCategories().then((value) {
      setState(() {
        productCategories.addAll(value);
      });
    });
  }

  addProduct() async {
    // ProductClient().addProduct(product)

    final product = ProductModel(
      id: const Uuid().v4(),
      productName: nameController.text,
      description: descriptionController.text,
      price: int.parse(priceController.text),
      categoryName: categoryController.text,
      quantity: int.parse(quantityController.text),
      isActive: statusController.text == 'Active' ? 1 : 0,
      isSelling: sellingStatusController.text == 'Selling' ? 1 : 0,
    );

    final uploadClient = UploadFileClient();

    // Upload avatar
    if (avatar.isNotEmpty) {
      final pathOfFile = avatar;
      final path =
          'products/${avatar.split('/')[avatar.split('/').length - 1]}';
      await uploadClient.uploadFileByPath(pathOfFile, path).then((value) {
        // product.avatarUrl = value;
        product.urlImage = value;
      });
    } else {
      // Show error message
      Message.showToast(context, 'Please select avatar');
    }

    final productClient = ProductClient();
    productClient.addProduct(product).then((value) {
      Message.showToast(context, 'Add product successfully');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // close the keyboard when you tap outside the textfield
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: const Text('Add Product'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  autofocus: true,
                  controller: nameController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter product name'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter product name',
                    fillColor: const Color.fromARGB(255, 126, 126, 126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: priceController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter product price'
                      : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                      labelText: 'Price',
                      hintText: 'Enter product price',
                      fillColor: const Color.fromARGB(255, 126, 126, 126),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      )),
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter product description',
                    fillColor: const Color.fromARGB(255, 126, 126, 126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                DropdownButtonFormField(
                  validator: (value) => value == null
                      ? 'Please select product category'
                      : null,
                  decoration: InputDecoration(
                    // labelText: 'Category',
                    label: const Text('Category'),
                    hintText: 'Select product category',
                    fillColor: const Color.fromARGB(255, 126, 126, 126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  items: productCategories
                      .map((ProductCategoryModel productCategory) {
                    return DropdownMenuItem(
                      value: productCategory.categoryId,
                      child: Text(productCategory.categoryName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    categoryController.text = productCategories
                        .firstWhere((element) => element.categoryId == value)
                        .categoryName;
                  },
                ),
                // TextFormField(
                //   controller: categoryController,
                //   validator: (value) => value == null || value.isEmpty
                //       ? 'Please enter product category'
                //       : null,
                //   // inputFormatters: [
                //   //   FilteringTextInputFormatter.digitsOnly,
                //   // ],
                //   decoration: InputDecoration(
                //     labelText: 'Category',
                //     hintText: 'Enter product category',
                //     fillColor: const Color.fromARGB(255, 126, 126, 126),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //       borderSide: const BorderSide(color: Colors.grey),
                //     ),
                //   ),
                // ),


                const SizedBox(height: 16.0),

                TextFormField(
                  controller: quantityController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter product quantity'
                      : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter product quantity',
                    fillColor: const Color.fromARGB(255, 126, 126, 126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                // avatar selection
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

                // image selection
                // Material(
                //   // shadowColor: Colors.black,
                //   // elevation: 5.0,
                //   borderRadius: BorderRadius.circular(10.0),
                //   child: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const Text(
                //           'Select Images',
                //           style: TextStyle(fontSize: 14.0),
                //           textAlign: TextAlign.left,
                //         ),
                //         const SizedBox(height: 8.0),
                //         InkWell(
                //           onTap: () async {
                //             showActionSheet();
                //           },
                //           child: Container(
                //             height: 100.0,
                //             padding: const EdgeInsets.all(8.0),
                //             decoration: BoxDecoration(
                //               color: Colors.transparent,
                //               borderRadius: BorderRadius.circular(10.0),
                //               border:
                //                   Border.all(color: Colors.grey, width: 1.0),
                //             ),
                //             child: images.isEmpty
                //                 ? const Center(
                //                     child: Icon(
                //                       Icons.add_a_photo,
                //                       color: Colors.grey,
                //                       size: 40.0,
                //                     ),
                //                   )
                //                 : ListView.builder(
                //                     scrollDirection: Axis.horizontal,
                //                     itemCount: images.length,
                //                     itemBuilder: (context, index) {
                //                       // Image with remove button
                //                       return Stack(
                //                         children: [
                //                           Container(
                //                             margin: const EdgeInsets.only(
                //                                 right: 8.0),
                //                             height: 100.0,
                //                             width: 100.0,
                //                             decoration: BoxDecoration(
                //                               color: const Color.fromARGB(
                //                                   255, 126, 126, 126),
                //                               borderRadius:
                //                                   BorderRadius.circular(10.0),
                //                             ),
                //                             child: Image.file(
                //                               File(images[index]),
                //                               height: 100.0,
                //                               width: 100.0,
                //                               fit: BoxFit.cover,
                //                             ),
                //                           ),
                //                           Positioned(
                //                             top: 0,
                //                             right: 0,
                //                             child: InkWell(
                //                               onTap: () {
                //                                 images.removeAt(index);
                //                                 setState(() {});
                //                               },
                //                               child: Container(
                //                                 height: 30.0,
                //                                 width: 30.0,
                //                                 decoration: BoxDecoration(
                //                                   color: Colors.red,
                //                                   borderRadius:
                //                                       BorderRadius.circular(
                //                                           15.0),
                //                                 ),
                //                                 child: const Icon(
                //                                   Icons.close,
                //                                   color: Colors.white,
                //                                   size: 20.0,
                //                                 ),
                //                               ),
                //                             ),
                //                           )
                //                         ],
                //                       );
                //                     },
                //                   ),
                //           ),
                //         )
                //       ]),
                // ),

                // const SizedBox(height: 16.0),

                // Select status
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Status',
                    hintText: 'Select product status',
                    fillColor: const Color.fromARGB(255, 126, 126, 126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  items: listStatus.map((status) {
                    return DropdownMenuItem(
                      value: status['id'],
                      child: Text(status['name'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    statusController.text = listStatus.firstWhere(
                        (element) => element['id'] == value)['name'] as String;
                  },
                ),

                const SizedBox(height: 16.0),

                // Select selling status
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Selling Status',
                    hintText: 'Select product selling status',
                    fillColor: const Color.fromARGB(255, 126, 126, 126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  items: listSellingStatus.map((status) {
                    return DropdownMenuItem(
                      value: status['id'],
                      child: Text(status['name'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    sellingStatusController.text = listSellingStatus.firstWhere(
                        (element) => element['id'] == value)['name'] as String;
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );

                      addProduct();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            )),
      ),
    );
  }

  selectAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      avatar = pickedFile.path;
      setState(() {});
    }
  }

  showActionSheet() async {
    final action = CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                Icon(Icons.photo, size: 24),
                SizedBox(width: 16),
                Text('Chọn trong thư viện',
                    style: TextStyle(color: Color(0xff333333), fontSize: 14)),
              ],
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            showGallery();
          },
        ),
        CupertinoActionSheetAction(
          child: const Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                Icon(Icons.camera, size: 24),
                SizedBox(width: 16),
                Text('Chụp ảnh',
                    style: TextStyle(color: Color(0xff333333), fontSize: 14)),
              ],
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            showCamera();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Huỷ',
            style: TextStyle(color: Color(0xff333333), fontSize: 14)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  showGallery() async {
    try {
      final picker = ImagePicker();
      List<XFile> pickedFiles = [];

      final status = await Permission.photos.request();
      if (status.isDenied || status.isGranted) {
        pickedFiles =
            await picker.pickMultiImage(maxHeight: 840, maxWidth: 840);
      } else {
        final result = await showPopupConfirm(
          title: 'Cấp Quyền',
          description:
              'Bạn có muốn cấp quyền truy cập hình ảnh cho ứng dụng không?',
        );
        if (result != null && result) {
          openAppSettings();
        }
      }

      if (pickedFiles.isNotEmpty) {
        images = pickedFiles.map((e) => e.path).toList();
        setState(() {});
      }
    } catch (e) {
      BotToast.closeAllLoading();
      Message.showToast(context, e.toString());
    }
  }

  showCamera() async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile;

      final status = await Permission.camera.status; //.request();
      if (status.isDenied || status.isGranted) {
        pickedFile = await picker.pickImage(
            source: ImageSource.camera, maxHeight: 840, maxWidth: 840);
      } else {
        final result = await showPopupConfirm(
            title: 'Cấp quyền',
            description:
                'Bạn có muốn cấp quyền truy cập máy ảnh cho ứng dụng không?');
        if (result != null && result) {
          openAppSettings();
        }
      }

      if (pickedFile != null) {
        images.add(pickedFile.path);
        setState(() {});
      } else {
        BotToast.closeAllLoading();
      }
    } catch (e) {
      BotToast.closeAllLoading();
      Message.showToast(context, e.toString());
    }
  }
}
