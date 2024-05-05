
import 'package:firebase_database/firebase_database.dart';
import 'package:sixcomputer/src/model/ordder_item_model.dart';

class OrderItemClient {
  DatabaseReference ref = FirebaseDatabase.instance.ref('OrderItem');

  Future<List<OrderItemModel>> getAllOrderItems() async {

    final productRaw = await ref.once();

    final List<OrderItemModel> orderItem = [];

    if (productRaw.snapshot.value != null) {
      final Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(productRaw.snapshot.value as Map<dynamic, dynamic>);

      data.forEach((key, value) {
        orderItem.add(OrderItemModel.fromJson(value as Map<dynamic, dynamic>));
      });
    }

    return orderItem;
  }

  Future<void> deleteOrderItem(String key) async {
    await ref.child(key).remove();
  }
}