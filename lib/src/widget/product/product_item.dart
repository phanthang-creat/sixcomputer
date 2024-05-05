import 'package:flutter/material.dart';
import 'package:sixcomputer/src/model/product_model.dart';
import 'package:intl/intl.dart';
import 'package:sixcomputer/src/repo/product_repo.dart';
import 'package:sixcomputer/src/repo/upload_file.dart';
import 'package:sixcomputer/src/widget/product/product_detail_view.dart';
import 'package:sixcomputer/src/widget/product/product_edit_view.dart';

class ProductItem extends StatefulWidget {
  final ProductModel productModel;
  const ProductItem({super.key, required this.productModel});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  void initState() {
    super.initState();
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Product'),
            content: const Text('Are you sure you want to delete this product?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    deleteProduct();
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'))
            ],
          );
        });
  }

  deleteProduct() {
    try {
      final productClient = ProductClient();
      // final UploadFileClient uploadFileClient = UploadFileClient();

      // for (final imageUrl in widget.productModel.images!) {
      //   // final fileName = imageUrl.split('/').last;
      //   uploadFileClient.deleteFile(imageUrl);
      // }

      // uploadFileClient.deleteFile(widget.productModel.urlImage!);

      productClient.deleteProduct(widget.productModel.id!);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')));

      
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailView.routeName,
            arguments: {'id': widget.productModel.id});
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 6.0)
                ]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInImage(
                    width: 80,
                    height: 80,
                    placeholder:
                        const AssetImage('assets/images/placeholder.png'),
                    image: NetworkImage(widget.productModel.urlImage ?? ''),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.productModel.productName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 5),
                                Text(NumberFormat.currency(
                                        locale: 'vi', symbol: '₫')
                                    .format(widget.productModel.price)),
                                const SizedBox(height: 5),
                                Text(widget.productModel.categoryName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12)),
                              ]),
                        ),
                        //Edit and delete
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, ProductEditView.routeName,
                                    arguments: {'id': widget.productModel.id});
                              },
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.blue,
                              )
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                showAlert();
                              },
                              child: const Icon(
                                Icons.delete_outlined,
                                color: Colors.red,
                              )
                            ),
                          ],
                        )
                      ],
                    )
                  ]))
                ]),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
