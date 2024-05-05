import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sixcomputer/src/help/show_message.dart';
import 'package:sixcomputer/src/model/order_model.dart';
import 'package:sixcomputer/src/repo/order_repo.dart';

class OrderListView extends StatefulWidget {
  
  const OrderListView({super.key, required this.orders});

  final List<OrderModel> orders;

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {

  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _orders = widget.orders;
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
                          updateOrderStatus(_orders[index].id ?? '', 'Ongoing');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          // Cancel order
                          updateOrderStatus(_orders[index].id ?? '', 'Cancel');

                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
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