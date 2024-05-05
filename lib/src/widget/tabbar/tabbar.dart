import 'package:flutter/material.dart';
import 'package:sixcomputer/src/widget/dashboard/dashboard.dart';
import 'package:sixcomputer/src/widget/order/order_view.dart';
import 'package:sixcomputer/src/widget/product/product_list_view.dart';
import 'package:sixcomputer/src/widget/product_category/product_category_list_view.dart';
import 'package:sixcomputer/src/widget/settings/settings_controller.dart';
import 'package:sixcomputer/src/widget/settings/settings_view.dart';

class TabbarController extends StatefulWidget {
  const TabbarController({super.key, required this.settingsController});

  static const String routeName = '/tabbar';

  final SettingsController settingsController;

  @override
  State<TabbarController> createState() => _TabbarControllerState();
}

class _TabbarControllerState extends State<TabbarController> {
  PageController pageController = PageController();
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            const Dashboard(),
            const ProductListView(),
            const OrderTabbar(),
            SettingsView(
              controller: widget.settingsController,
              pageController: pageController,
            ),
            const ProductCategoriesListView()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Product',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Orders',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu), 
              label: 'Menu',
              backgroundColor: Colors.blue
            )
          ],
          backgroundColor: Colors.blue,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedIconTheme: const IconThemeData(color: Colors.white),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              pageController.jumpToPage(index);
            });
          },
        ));
  }
}
