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

class ProductEditView extends StatefulWidget {
  final String id;
  const ProductEditView({super.key, required this.id});

  static const String routeName = '/product-edit';

  @override
  State<ProductEditView> createState() => _ProductEditViewState();
}

class _ProductEditViewState extends State<ProductEditView> {
  final _formKey = GlobalKey<FormState>();

  final List<ProductCategoryModel> productCategories = [];
  final ProductClient productClient = ProductClient();
  final ProductCategoriesClient productCategoriesClient = ProductCategoriesClient();
  late ProductModel product;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchProductCategories() async {
    final categories = await productCategoriesClient.fetchProductCategories();
    setState(() {
      productCategories.addAll(categories);
    });
  }

  fetchProductById() async {
    final product = await productClient.getProductById(widget.id);

    nameController.text = product.productName ?? '';

    priceController.text = product.price.toString();

    descriptionController.text = product.description ?? '';

    categoryController.text = productCategories
        .firstWhere((element) => element.categoryName == product.categoryName)
        .categoryId ?? '';

    quantityController.text = product.quantity.toString();

    statusController.text = product.isActive == 1 ? 'Active' : 'Inactive';

    sellingStatusController.text = product.isSelling == 1 ? 'Selling' : 'Not Selling';

    avatar = product.urlImage ?? '';

    this.product = product;

    setState(() {});
  }

  fetchData() async {
    await fetchProductCategories();
    await fetchProductById();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController sellingStatusController = TextEditingController();

  String categoryValue = '';

  List<String> listDeleteImages = [];
  List<String> listNewImages = [];

  String avatar = '';
  List<String> images = [];

  final uploadClient = UploadFileClient();

  final listStatus = [
    {'id': 1, 'name': 'Active'},
    {'id': 0, 'name': 'Inactive'}
  ];

  final listSellingStatus = [
    {'id': 1, 'name': 'Selling'},
    {'id': 0, 'name': 'Not Selling'}
  ];

  updateProduct() async {
    final product = this.product;

    product.productName = nameController.text;

    product.price = int.parse(priceController.text);

    product.description = descriptionController.text;

    product.categoryName = productCategories
        .firstWhere((element) => element.categoryId == categoryController.text)
        .categoryName;

    product.quantity = int.parse(quantityController.text);

    product.isActive = listStatus
        .firstWhere((element) => element['name'] == statusController.text)['id'] as int?;

    product.isSelling = listSellingStatus
        .firstWhere((element) => element['name'] == sellingStatusController.text)['id'] as int?;

    // Upload avatar
    if (avatar.isNotEmpty) {
      if (avatar.startsWith('https://')) {
      } else {
        final pathOfFile = avatar;
        final path =
            'products/${product.id}/${avatar.split('/')[avatar.split('/').length - 1]}';
        final url = await uploadClient.uploadFileByPath(pathOfFile, path);
        product.urlImage = url;
      }
    } else {
      // Show error message
      Message.showToast(context, 'Please select avatar');
    }

    productClient.updateProduct(product).then((value) {
      Message.showToast(context, 'Update product successfully');
    });
  }

  deleteProduct() async {

    // for (var image in product.images!) {
    //   await uploadClient.deleteFile(image);
    // }

    productClient.deleteProduct(widget.id).then((value) {
      Message.showToast(context, 'Delete product successfully');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // close the keyboard when you tap outside the textfield
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: const Text('Edit Product'),
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
                  // autofocus: true,
                  controller: nameController,
                  validator: (value) => 
                    value == null || value.isEmpty ? 'Please enter product name' : null,
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
                  validator: (value) => 
                    value == null || value.isEmpty ? 'Please enter product price' : null,
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
                    ),
                  ),
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
                  value: categoryController.text,
                  validator: (value) => 
                    value == null ? 'Please select product category' : null,
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
                    categoryController.text = value.toString();
                    print(value);
                  },
                ),

                const SizedBox(height: 16.0),

                TextFormField(
                  controller: quantityController,
                  validator: (value) => 
                    value == null || value.isEmpty ? 'Please enter product quantity' : null,
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
                Column(
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
                              : avatar.startsWith('https://')
                                  ? FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/placeholder.png',
                                      image: avatar,
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
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
                //               border: Border.all(color: Colors.grey, width: 1.0),
                //             ),
                //             child: images.isEmpty
                //                 ? const Center(
                //                     child: Icon(
                //                       Icons.add_a_photo,
                //                       color: Colors.white,
                //                       size: 40.0,
                //                     ),
                //                   )
                //                 : ListView.builder(
                //                     scrollDirection: Axis.horizontal,
                //                     itemCount: images.length,
                //                     itemBuilder: (context, index) {
                //                       return Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Stack(
                //                           children: [
                //                             images[index].toString().contains('https://')
                //                                 ? FadeInImage.assetNetwork(
                //                                     placeholder:
                //                                         'assets/images/placeholder.png',
                //                                     image: images[index],
                //                                     height: 100.0,
                //                                     width: 100.0,
                //                                     fit: BoxFit.cover,
                //                                   ) :
                //                                 Image.file(
                //                                     File(images[index]),
                //                                     height: 100.0,
                //                                     width: 100.0,
                //                                     fit: BoxFit.cover,
                //                                   ),
                //                             Positioned(
                //                               top: 0,
                //                               right: 0,
                //                               child: InkWell(
                //                                 onTap: () {
                //                                   images.removeAt(index);
                //                                   if (images[index].contains('https://')) {
                //                                     listDeleteImages.add(images[index]);
                //                                   }
                //                                   setState(() {});
                //                                 },
                //                                 child: Container(
                //                                   decoration: BoxDecoration(
                //                                     color: Colors.red,
                //                                     borderRadius:
                //                                         BorderRadius.circular(10.0),
                //                                   ),
                //                                   child: const Icon(
                //                                     Icons.close,
                //                                     color: Colors.white,
                //                                   ),
                //                                 ),
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                       );
                //                     },
                //                   ),
                //           ),
                //         )
                //       ]),
                // ),

                const SizedBox(height: 16.0),

                // Select status
                // DropdownButtonFormField(
                //   value: statusController.text,
                //   decoration: InputDecoration(
                //     labelText: 'Status',
                //     hintText: 'Select product status',
                //     fillColor: const Color.fromARGB(255, 126, 126, 126),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //       borderSide: const BorderSide(color: Colors.grey),
                //     ),
                //   ),
                //   items: listStatus.map((status) {
                //     return DropdownMenuItem(
                //       value: status['id'],
                //       child: Text(status['name'] as String),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     statusController.text = listStatus.firstWhere(
                //         (element) => element['id'] == value)['name'] as String;
                //   },
                // ),

                // const SizedBox(height: 16.0),

                // // Select selling status
                // DropdownButtonFormField(
                //   value: sellingStatusController.text,
                //   decoration: InputDecoration(
                //     labelText: 'Selling Status',
                //     hintText: 'Select product selling status',
                //     fillColor: const Color.fromARGB(255, 126, 126, 126),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //       borderSide: const BorderSide(color: Colors.grey),
                //     ),
                //   ),
                //   items: listSellingStatus.map((status) {
                //     return DropdownMenuItem(
                //       value: status['id'],
                //       child: Text(status['name'] as String),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     sellingStatusController.text = listSellingStatus.firstWhere(
                //         (element) => element['id'] == value)['name'] as String;
                //   },
                // ),

                const SizedBox(height: 16.0),
                // Submit button and cancel button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateProduct();
                        }
                      },
                      child: const Text('Update'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        deleteProduct();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                )
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
        List<String> newImages = [];
        for (var file in pickedFiles) {
          newImages.add(file.path);
        }
        images.addAll(newImages);
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
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
