import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sixcomputer/src/app_settings/app_settings.dart';
import 'package:sixcomputer/src/widget/coupon/coupon_add_view.dart';
import 'package:sixcomputer/src/widget/coupon/coupon_edit_view.dart';
import 'package:sixcomputer/src/widget/dashboard/dashboard.dart';
import 'package:sixcomputer/src/widget/product/product_add_view.dart';
import 'package:sixcomputer/src/widget/product/product_detail_view.dart';
import 'package:sixcomputer/src/widget/product/product_edit_view.dart';
import 'package:sixcomputer/src/widget/product_category/product_category_add.dart';
import 'package:sixcomputer/src/widget/sign_in/sign_in_view.dart';
import 'package:sixcomputer/src/widget/tabbar/tabbar.dart';

import 'widget/sample_feature/sample_item_details_view.dart';
import 'widget/sample_feature/sample_item_list_view.dart';
import 'widget/settings/settings_controller.dart';
import 'widget/settings/settings_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,

          navigatorKey: navigatorKey,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            switch (routeSettings.name) {
              case SampleItemDetailsView.routeName:
                return _buildRoute(
                  routeSettings,
                  const SampleItemDetailsView(),
                );
              case SampleItemListView.routeName:
                return _buildRoute(
                  routeSettings,
                  const SampleItemListView(),
                );
              // case SettingsView.routeName:
              //   return _buildRoute(
              //     routeSettings,
              //     SettingsView(controller: widget.settingsController),
              //   );
              case TabbarController.routeName:
                return _buildRoute(
                  routeSettings,
                  TabbarController(
                    settingsController: widget.settingsController,
                  ),
                );
              case ProductAddView.routeName:
                return _buildRoute(
                  routeSettings,
                  const ProductAddView(),
                );
              case ProductCategoryAddView.routeName:
                return _buildRoute(
                  routeSettings,
                  const ProductCategoryAddView(),
                );
              case ProductEditView.routeName:
                final args = routeSettings.arguments as Map<String, dynamic>;
                return _buildRoute(
                  routeSettings,
                  ProductEditView(id: args['id'] as String),
                );
              case ProductDetailView.routeName:
                final args = routeSettings.arguments as Map<String, dynamic>;
                return _buildRoute(
                  routeSettings,
                  ProductDetailView(id: args['id'] as String),
                );
              case SignInAdminView.routeName:
                return _buildRoute(
                  routeSettings,
                  const SignInAdminView(),
                );
              case Dashboard.routeName:
                return _buildRoute(
                  routeSettings,
                  const Dashboard(),
                );
                case CouponAddView.routeName:
                  return _buildRoute(
                  routeSettings,
                  const CouponAddView(),
                );
              case CouponEditView.routeName:
                final args = routeSettings.arguments as Map<String, dynamic>;
                return _buildRoute(
                  routeSettings,
                  CouponEditView(id: args['id'] as String),
                );
              default:
                return _buildRoute(
                  routeSettings,
                  TabbarController(
                    settingsController: widget.settingsController,
                  ),
                );
            }
          },
        );
      },
    );
  }
}

PageRoute _buildRoute(RouteSettings settings, Widget builder,
    {bool isPresent = false}) {
  if (isPresent) {
    return CupertinoPageRoute(
        fullscreenDialog: true, builder: (context) => builder);
  } else {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}