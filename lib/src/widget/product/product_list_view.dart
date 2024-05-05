
import 'package:flutter/material.dart';
import 'package:sixcomputer/src/model/product_model.dart';
import 'package:sixcomputer/src/repo/product_repo.dart';
import 'package:sixcomputer/src/widget/product/product_add_view.dart';
import 'package:sixcomputer/src/widget/product/product_item.dart';

class ProductListView extends StatefulWidget {
  // final int id;
  const ProductListView({super.key});

  static const String routeName = '/product-list';

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final List<ProductModel> products = [];

  final ProductClient productClient = ProductClient();
  final TextEditingController searchController = TextEditingController();

  bool isSearching = false;

  final List<ProductModel> searchProducts = [];

  @override
  void initState() {
    super.initState();

    // fetchProducts();
    fetchProducts2();
  }

  fetchProducts2() async {
    final products = await productClient.fetchProducts2();

    this.products.clear();
    this.products.addAll(products);
    setState(() {
    });
  }

  // fetchProducts() async {
  //   final products = await productClient.fetchProducts();
  //   setState(() {
  //     this.products.clear();
  //     this.products.addAll(products);
  //   });
  //   print("Products: $products");
  // }

  search(String query) async {

    if (query.isEmpty) {
      setState(() {
        isSearching = false;
      });
      return;
    }

    final products = this.products.where((element) {
      return element.productName!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    isSearching = true;
    setState(() {
      searchProducts.clear();
      searchProducts.addAll(products);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Products'),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  semanticLabel: 'add',
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, ProductAddView.routeName);
                },
              ),
            ],
          )
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              // fetchProducts();
              fetchProducts2();
            },
            child: products.isEmpty
                ? const Center(
                    child: Image(
                        width: 100,
                        height: 100,
                        image: AssetImage('assets/images/empty_box.png')),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            children: [
                              // SizedBox(
                              //   width: 40,
                              //   child: InkWell(
                              //     onTap: () {
                              //       // Navigator.pushNamed(context, ProductCategoryAddView.routeName);
                              //     },
                              //     child: const Icon(Icons.filter_list_rounded),
                              //   ),
                              // ),
                              Expanded(
                                child: SearchBar(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.white),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 16.0)),
                                  leading: const Icon(Icons.search),
                                  controller: searchController,
                                  trailing: [
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          isSearching = false;
                                          searchController.clear();
                                        });
                                      },
                                    ),
                                  ],
                                  hintText: 'Search product',
                                  onSubmitted: (value) {
                                    search(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      isSearching
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Text(
                                    'Search result: ${searchProducts.length}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            ),
                      isSearching
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product = searchProducts[index];
                                  return ProductItem(productModel: product);
                                },
                                childCount: searchProducts.length,
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product = products[index];
                                  return ProductItem(productModel: product);
                                },
                                childCount: products.length,
                              ),
                            ),
                    ],
                  )));
  }
}
