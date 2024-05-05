import 'package:flutter/material.dart';
import 'package:sixcomputer/src/model/ordder_item_model.dart';
import 'package:sixcomputer/src/model/order_model.dart';
import 'package:sixcomputer/src/repo/order_item_repo.dart';
import 'package:sixcomputer/src/repo/order_repo.dart';
import 'package:sixcomputer/src/widget/order/order_cancel_view.dart';
import 'package:sixcomputer/src/widget/order/order_complete_view.dart';
import 'package:sixcomputer/src/widget/order/order_ongoing_view.dart';
import 'package:sixcomputer/src/widget/order/order_trash_complete.dart';
import 'dart:math' as math;

import 'package:sixcomputer/src/widget/order/order_waiting_view.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class OrderTabbar extends StatefulWidget {
  const OrderTabbar({super.key});

  @override
  State<OrderTabbar> createState() => _OrderTabbarState();
}

class _OrderTabbarState extends State<OrderTabbar> {

  int selectedIndex = 0;

  final List<OrderModel> _orders = [];

  List<OrderItemModel> orderItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    List<OrderModel> orders = await OrderClient().getAllOrders();
    List<OrderItemModel> orderItems = await OrderItemClient().getAllOrderItems();

    for (var order in orders) {
      if (order.id != null) {
        for (var orderItem in orderItems) {
          if (order.id == orderItem.orderId) {
            order.orderItems.add(orderItem);
          }
        }

        _orders.add(order);
      }
    }

    setState(() {
    });
  }

  filterOrder(String status) {
    List<OrderModel> orders = _orders.where((element) => element.status == status).toList();
    return orders;
  }

  final PageController pageController = PageController();

  final List<String> _tabsImage = [
    'assets/images/tab_1.png',
    'assets/images/tab_2.png',
    'assets/images/tab_3.png',
    'assets/images/tab_4.png',
    'assets/images/tab_5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _tabsImage.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(index);
                    selectedIndex = index;
                    setState(() {
                    });
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == index
                              ? Colors.blue
                              : Colors.grey[200]!,
                          width: 2,
                      ),)
                    ),
                    child: Image.asset(
                      _tabsImage[index],
                      width: 30,
                      height: 30,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                OrderListWaitingView(),
                OrderListOnGoingView(),
                OrderListCompletedView(),
                OrderListCancelView(),
                OrderListTrashView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
