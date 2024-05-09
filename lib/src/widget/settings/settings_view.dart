import 'package:flutter/material.dart';
import 'package:sixcomputer/src/app_settings/app_settings.dart';
import 'package:sixcomputer/src/widget/coupon/coupon_list_view.dart';
import 'package:sixcomputer/src/widget/sign_in/sign_in_view.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller, required this.pageController});

  static const routeName = '/settings';

  final SettingsController controller;

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                pageController.jumpToPage(4);
              },
              child: const Row(
                children: [
                  Icon(Icons.category),
                  SizedBox(width: 8),
                  Text('Categories'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                pageController.jumpToPage(5);
              },
              child: const Row(
                children: [
                  Icon(Icons.discount),
                  SizedBox(width: 8),
                  Text('Coupons'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                AppSettings.setIsLogin('false');
                Navigator.pushReplacementNamed(context, SignInAdminView.routeName);
              },
              child: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
            // DropdownButton<ThemeMode>(
            //   // Read the selected themeMode from the controller
            //   value: controller.themeMode,
            //   // Call the updateThemeMode method any time the user selects a theme.
            //   onChanged: controller.updateThemeMode,
            //   items: const [
            //     DropdownMenuItem(
            //       value: ThemeMode.system,
            //       child: Text('System Theme'),
            //     ),
            //     DropdownMenuItem(
            //       value: ThemeMode.light,
            //       child: Text('Light Theme'),
            //     ),
            //     DropdownMenuItem(
            //       value: ThemeMode.dark,
            //       child: Text('Dark Theme'),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
