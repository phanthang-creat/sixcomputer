
import 'package:firebase_database/firebase_database.dart';
import 'package:sixcomputer/src/model/order_model.dart';

class OrderClient {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Order');

  Future<List<OrderModel>> getAllOrders() async {

    final productRaw = await ref.once();

    final List<OrderModel> order = [];

    if (productRaw.snapshot.value != null) {
      final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(productRaw.snapshot.value as Map<dynamic, dynamic>);

      data.forEach((key, value) {
        order.add(OrderModel.fromJson(value as Map<dynamic, dynamic>, key as String));
      });
    }

    return order;
  }

  Future<void> updateOrder(OrderModel order) async {

    // try to fetch the order key
    if (order.key == null) {
      print(await getOrder(order.key as String));
    }

    await FirebaseDatabase.instance.ref('Order/${order.key}').update(order.toJson());
  }

  Future<OrderModel> getOrder(String key) async {
    final orderRaw = await ref.child(key).once();

    if (orderRaw.snapshot.value != null) {
      return OrderModel.fromJson(orderRaw.snapshot.value as Map<dynamic, dynamic>, key);
    }

    return OrderModel();
  }

  Future<void> deleteOrder(String key) async {
    await ref.child(key).remove();
  }
}