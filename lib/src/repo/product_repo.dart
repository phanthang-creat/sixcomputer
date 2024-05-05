
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sixcomputer/src/model/product_model.dart';

class ProductClient {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  FirebaseDatabase intance = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref('Product');

  Future<void> addProduct(ProductModel product) async { 
    await FirebaseDatabase.instance.ref('Product/${product.id}').set(product.toJson());
  }
  Future<List<ProductModel>> fetchProducts2() async {
    final productsChild = await ref.once();

    print("Products: ${productsChild.snapshot.value}");

    final List<ProductModel> products = [];

    if (productsChild.snapshot.value != null) {
      final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(productsChild.snapshot.value as Map<dynamic, dynamic>);

      data.forEach((key, value) {
        products.add(ProductModel.fromJson(value as Map<dynamic, dynamic>));
      });
    }

    return products;
  }

  // Future<List<ProductModel>> fetchProducts() async {
  //   final products = await firestore.collection('products').get();

  //   return [];
   
  // }

  Future<void> updateProduct(ProductModel product) async {
    await FirebaseDatabase.instance.ref('Product/${product.id}').update(product.toJson());
  }

  Future<void> deleteProduct(String id) async {
    await FirebaseDatabase.instance.ref('Product/$id').remove();
  }

  Future<ProductModel> getProductById(String id) async {

    final product = await FirebaseDatabase.instance.ref().child('Product').child(id).once();

    return ProductModel.fromJson(product.snapshot.value as Map<dynamic, dynamic>);
  }

  Future<List<ProductModel>> searchProduct(String query) async {
    final products = await firestore.collection('products').where('name', isEqualTo: query).get();

    // return products.docs.map((e) => ProductModel.fromMap(e.data(), e.id)).toList();
    return [];
  }
}