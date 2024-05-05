
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sixcomputer/src/model/product_category_model.dart';


class ProductCategoriesClient {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref('Category');
  
  Future<List<ProductCategoryModel>> fetchProductCategories() async {
    // Use the http package to fetch product categories from a web server.
    final List<ProductCategoryModel> productCategories = [];
    
    final productCategoriesChild = await ref.once();

    if (productCategoriesChild.snapshot.value != null) {
      final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(productCategoriesChild.snapshot.value as Map<dynamic, dynamic>);

      data.forEach((key, value) {
        productCategories.add(ProductCategoryModel.fromJson(value as Map<dynamic, dynamic>));
      });
    }

    return productCategories;
  }

  Future<void> addProductCategory(ProductCategoryModel productCategory) async {
    await FirebaseDatabase.instance.ref('Category/${productCategory.categoryId}').set(productCategory.toJson());
  }
}