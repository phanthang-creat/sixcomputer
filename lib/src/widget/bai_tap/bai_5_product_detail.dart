import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sixcomputer/src/widget/bai_tap/bai_5.dart';
import 'package:sixcomputer/src/widget/bai_tap/bai_5_product_model.dart';

class Bai5ProductDetailView extends StatefulWidget {
  final String id;
  const Bai5ProductDetailView({super.key, required this.id});

  static const String routeName = '/bai-5/product-detail';

  @override
  State<Bai5ProductDetailView> createState() => _Bai5ProductDetailViewState();
}

class _Bai5ProductDetailViewState extends State<Bai5ProductDetailView> {

  Bai5ProductModel? product;

  @override
  void initState() {
    super.initState();

    product = Bai5.globalProducts.firstWhere((element) => element.id == widget.id);
    productCodeController.text = product!.id;
    productNameController.text = product!.name;
    productPriceController.text = product!.price.toString();
  }

  TextEditingController productCodeController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  editProduct() {
    final product = Bai5ProductModel(
      id: productCodeController.text,
      name: productNameController.text,
      price: double.parse(productPriceController.text),
      categoryId: Bai5.globalProducts.firstWhere((element) => element.id == widget.id).categoryId,
      image: Bai5.globalProducts.firstWhere((element) => element.id == widget.id).image,
    );

    final index = Bai5.globalProducts.indexWhere((element) => element.id == widget.id);
    Bai5.globalProducts[index] = product;

    setState(() {
    });

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Bai5()));
  }

  deleteProduct() {
    Bai5.globalProducts.removeWhere((element) => element.id == widget.id);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Bai5()));
  }

  cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: productCodeController..text = product!.id,
              decoration: const InputDecoration(
                labelText: 'Product Code',
              ),
            ),
            TextFormField(
              controller: productNameController..text = product!.name,
              decoration: const InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            TextFormField(
              controller: productPriceController..text = product!.price.toString(),
              decoration: const InputDecoration(
                labelText: 'Product Price',
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: editProduct,
                  child: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: deleteProduct,
                  child: const Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}