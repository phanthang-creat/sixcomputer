import 'package:flutter/material.dart';
import 'package:sixcomputer/src/model/product_category_model.dart';
import 'package:sixcomputer/src/repo/product_categories_repo.dart';
import 'package:sixcomputer/src/widget/product_category/product_category_add.dart';

class ProductCategoriesListView extends StatefulWidget {
  const ProductCategoriesListView({super.key});

  @override
  State<ProductCategoriesListView> createState() => _ProductCategoriesListViewState();
}

class _ProductCategoriesListViewState extends State<ProductCategoriesListView> {

  final List<ProductCategoryModel> productCategories = [];

  getProductCategories() async {
    ProductCategoriesClient().fetchProductCategories().then((value) {
      setState(() {
        productCategories.addAll(value);
      });
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
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        title: const Text("Product Categories"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ProductCategoryAddView.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView.separated(
        itemCount: productCategories.length, 
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: FadeInImage(
                        placeholder: const AssetImage("assets/images/placeholder.png"),
                        image: NetworkImage(productCategories[index].categoryImage ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(productCategories[index].categoryName),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, ProductEditView.routeName,
                        //     arguments: {'id': widget.productModel.id});
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.blue,
                      )
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        // showAlert();
                      },
                      child: const Icon(
                        Icons.delete_outlined,
                        color: Colors.red,
                      )
                    ),
                  ],
                )
              ],
            ),
          );
        },

        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        
      )
    );
  }
}