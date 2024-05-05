import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixcomputer/src/widget/bai_tap/bai_5_product_category_model.dart';
import 'package:sixcomputer/src/widget/bai_tap/bai_5_product_model.dart';

class Bai5 extends StatefulWidget {
  const Bai5({super.key});

  static const String routeName = '/bai-5';

  static final List<Bai5ProductModel> globalProducts = [];

  static final List<Bai5ProductCategoryModel> categories = [
    Bai5ProductCategoryModel(name: 'Category 1', id: 1),
    Bai5ProductCategoryModel(name: 'Category 2', id: 2),
    Bai5ProductCategoryModel(name: 'Category 3', id: 3),
  ];

  @override
  State<Bai5> createState() => _Bai5State();
}

class _Bai5State extends State<Bai5> {
  TextEditingController productCodeController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  int productCategoryController = 1;

  // List<Bai5ProductModel> products = Bai5.globalProducts;

  String image = '';

  addProduct() {
    final product = Bai5ProductModel(
      id: productCodeController.text,
      name: productNameController.text,
      price: double.parse(productPriceController.text),
      categoryId: 1,
      image: image,
    );

    setState(() {
      // products.add(product);
    });

    Bai5.globalProducts.add(product);
  }

  deleteProuct() {
    // delete by id
    for (var i = 0; i < Bai5.globalProducts.length; i++) {
      if (Bai5.globalProducts[i].id == productCodeController.text) {
        Bai5.globalProducts.removeAt(i);

        Bai5.globalProducts.removeWhere((element) => element.id == productCodeController.text);
        setState(() {});
        break;
      }
    }
  }

  editProduct() {
    // edit by id
    for (var i = 0; i < Bai5.globalProducts.length; i++) {
      if (Bai5.globalProducts[i].id == productCodeController.text) {
        Bai5.globalProducts[i].name = productNameController.text;
        Bai5.globalProducts[i].price = double.parse(productPriceController.text);
        Bai5.globalProducts[i].image = image;

        setState(() {});
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bai 5'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Form(
                child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: productCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Product code',
                    ),
                  ),
                  TextFormField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      labelText: 'Product name',
                    ),
                  ),
                  TextFormField(
                    controller: productPriceController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Product price',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton(
                        onChanged: (value) {
                          productCategoryController = value as int;
                          setState(() {});
                        },
                        value: productCategoryController,
                        items: Bai5.categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ),
                      
                      InkWell(
                        onTap: selectImage,
                        child: image.isEmpty
                            ? const Icon(Icons.add_a_photo)
                            : Image.file(
                                File(image),
                                width: 100,
                                height: 100,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: addProduct,
                        child: const Text('Add product'),
                      ),
                      ElevatedButton(
                          onPressed: deleteProuct, child: const Text('Delete')),
                      ElevatedButton(
                          onPressed: editProduct, child: const Text('Edit')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Exit')),
                    ],
                  ),
                ],
              ),
            )),
            ListView.builder(
              shrinkWrap: true,
              itemCount: Bai5.globalProducts.length,
              itemBuilder: (context, index) {
                final product = Bai5.globalProducts[index];
                return InkWell(
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.id),
                        Text(product.price.toString()),
                      ],
                    ),
                    leading: Image.file(File(product.image)),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/bai-5/product-detail',
                            arguments: {'id': product.id});
                      },
                      child: const Text('Detail'),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // image picker
  selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile.path;
      setState(() {});
    }
  }
}
