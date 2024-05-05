import 'package:flutter/material.dart';
import 'package:sixcomputer/src/model/product_category_model.dart';
import 'package:sixcomputer/src/model/product_model.dart';
import 'package:sixcomputer/src/repo/product_categories_repo.dart';
import 'package:sixcomputer/src/repo/product_repo.dart';
import 'package:sixcomputer/src/repo/upload_file.dart';

class ProductDetailView extends StatefulWidget {
  final String id;
  const ProductDetailView({super.key, required this.id});

  static const String routeName = '/product-detail';

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductClient productClient = ProductClient();
  final UploadFileClient uploadFileClient = UploadFileClient();
  final ProductCategoriesClient productCategoriesClient = ProductCategoriesClient();

  final List<ProductCategoryModel> category = [];
  ProductModel product = ProductModel(
    id: '',
    // name: '',
    description: '',
    price: 0,
    quantity: 0,
    // categoryId: '',
    // statusId: 0,
    // images: [],
  );

  String selectedImage = '';

  @override
  void initState() {
    super.initState();

    fetchProduct();
    fetchProductCategory();
  }

  fetchProduct() async {
    final product = await productClient.getProductById(widget.id);

    setState(() {
      // this.product = product;
      // selectedImage = product.images!.first;
    });
  }

  fetchProductCategory() async {
    final categories = await productCategoriesClient.fetchProductCategories();

    setState(() {
      category.addAll(categories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/product-edit', arguments: {'id': product.id});
            },
          ),
        ],
      ),
      
      // show product detail
      // not edit
      body: product.id == ''
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Column(children: [
                      Center(
                        child: Image.network(
                          selectedImage,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     for (final image in product.images!)
                      //     Container(
                      //       margin: const EdgeInsets.only(right: 8),
                      //       decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: selectedImage == image
                      //               ? Colors.blue
                      //               : Colors.transparent,
                                
                      //         ),
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //       child: Material(
                      //         borderRadius: BorderRadius.circular(8),
                      //         elevation: 2,
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             setState(() {
                      //               selectedImage = image;
                      //             });
                      //           },
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Image.network(
                      //               image,
                      //               width: 50,
                      //               height: 50,
                      //               fit: BoxFit.cover,
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     )
                      //   ],
                      // ),
                    ]),
                    const SizedBox(height: 16),
                    // Text('Name: ${product.name}'),
                    const SizedBox(height: 16),
                    Text('Description: ${product.description}'),
                    const SizedBox(height: 16),
                    Text('Price: ${product.price}'),
                    const SizedBox(height: 16),
                    Text('Quantity: ${product.quantity}'),
                    const SizedBox(height: 16),
                    // category.isEmpty
                    //     ? const CircularProgressIndicator()
                    //     : Text(
                    //         'Category: ${category.firstWhere((element) => element.id == product.categoryId).name}'),
                    const SizedBox(height: 16),
                    // Text('Status: ${product.statusId}'),
                  ],
                ),
              ),
            ),
    );
  }
}
