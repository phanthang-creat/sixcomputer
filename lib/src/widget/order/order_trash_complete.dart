import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixcomputer/src/help/show_message.dart';
import 'package:sixcomputer/src/model/ordder_item_model.dart';
import 'package:sixcomputer/src/model/order_model.dart';
import 'package:sixcomputer/src/repo/order_item_repo.dart';
import 'package:sixcomputer/src/repo/order_repo.dart';

class OrderListTrashView extends StatefulWidget {
  
  const OrderListTrashView({super.key});

  @override
  State<OrderListTrashView> createState() => _OrderListTrashViewState();
}

class _OrderListTrashViewState extends State<OrderListTrashView> {

  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();

    if (_orders.isEmpty) {
      getOrderByStatus();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  getOrderByStatus() async {
    OrderClient ref = OrderClient();
    List<OrderModel> orders = await ref.getAllOrders();

    List<OrderItemModel> orderItems = await OrderItemClient().getAllOrderItems();

    _orders = orders.where((element) => element.status == 'trashComplete').toList();

    for (var order in _orders) {
      order.orderItems = orderItems.where((element) => element.orderId == order.id).toList();
    }

    setState(() {});
  }

  deleteOrder(String id) {
    OrderClient ref = OrderClient();

    ref.deleteOrder(id);

    OrderItemClient().deleteOrderItem(id);

    Message.showToast(context, 'Order deleted');
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: _orders.isEmpty ? 
      const Center(child: Text('No orders')) :
      ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order: ${_orders[index].id}'),
                      Text('${_orders[index].status}'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                for (var orderItem in _orders[index].orderItems)
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: FadeInImage(
                                placeholder: const AssetImage('assets/images/empty_box.png'),
                                image: NetworkImage(orderItem.urlImage ?? ''),
                              ),
                            ),
                            const SizedBox(width: 10), // Add this line
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(orderItem.productName ?? ''),
                                Text('Price: ${NumberFormat.currency(locale: 'vi').format(orderItem.price)}'),
                                Text('Quantity: ${orderItem.count}'),
                              ]
                            ),
                          ],
                        ),
                      ]
                    ),
                  ),
                
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))
                    ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total'),
                      Text(NumberFormat.currency(locale: 'vi').format(_orders[index].total))
                    ],
                  ),
                ),
                  
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payment Method'),
                      Text(_orders[index].paymentMethod ?? ''),
                    ],
                  ),
                ),
                  
                // Confirm and Cancel button
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      GestureDetector(
                        onTap: () {
                          // Cancel order
                          deleteOrder(_orders[index].key ?? '');

                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Delete', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}