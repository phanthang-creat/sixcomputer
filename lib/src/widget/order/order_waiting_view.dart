import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixcomputer/src/help/show_message.dart';
import 'package:sixcomputer/src/model/ordder_item_model.dart';
import 'package:sixcomputer/src/model/order_model.dart';
import 'package:sixcomputer/src/repo/order_item_repo.dart';
import 'package:sixcomputer/src/repo/order_repo.dart';

class OrderListWaitingView extends StatefulWidget {
  const OrderListWaitingView({super.key});

  @override
  State<OrderListWaitingView> createState() => _OrderListWaitingViewState();
}

class _OrderListWaitingViewState extends State<OrderListWaitingView> {
  List<OrderModel> _orders = [];

  bool _customTileExpanded = false;

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

    List<OrderItemModel> orderItems =
        await OrderItemClient().getAllOrderItems();

    _orders = orders.where((element) => element.status == 'Waiting').toList();

    for (var order in _orders) {
      order.orderItems =
          orderItems.where((element) => element.orderId == order.id).toList();
    }

    setState(() {});
  }

  updateOrderStatus(String id, String status) {
    OrderClient ref = OrderClient();

    OrderModel order = _orders.firstWhere((element) => element.id == id);

    order.status = status;

    ref.updateOrder(order);

    Message.showToast(context, 'Order status updated');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: _orders.isEmpty
          ? const Center(child: Text('No orders'))
          : ListView.builder(
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
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          padding: const EdgeInsets.all(10),
                          child: Row(children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: FadeInImage(
                                    placeholder: const AssetImage(
                                        'assets/images/empty_box.png'),
                                    image:
                                        NetworkImage(orderItem.urlImage ?? ''),
                                  ),
                                ),
                                const SizedBox(width: 10), // Add this line
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(orderItem.productName ?? ''),
                                      Text(
                                          'Price: ${NumberFormat.currency(locale: 'vi').format(orderItem.price)}'),
                                      Text('Quantity: ${orderItem.count}'),
                                    ]),
                              ],
                            ),
                          ]),
                        ),

                      Container(
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total'),
                            Text(NumberFormat.currency(locale: 'vi')
                                .format(_orders[index].total))
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Payment Method'),
                            Text(_orders[index].paymentMethod ?? ''),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Name'),
                                Text(_orders[index].fullname ?? ''),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Delivery Address'),
                                Text(_orders[index].address ?? ''),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Phone'),
                                Text(_orders[index].phone ?? ''),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Note'),
                                Text(_orders[index].note ?? ''),
                              ],
                            ),
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
                                updateOrderStatus(
                                    _orders[index].id ?? '', 'Ongoing');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('Confirm',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                // Cancel order
                                updateOrderStatus(
                                    _orders[index].id ?? '', 'Cancel');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.white)),
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
