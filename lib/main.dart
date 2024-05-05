import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sixcomputer/firebase_options.dart';
import 'package:sixcomputer/src/app_settings/app_preference.dart';
import 'package:sixcomputer/src/app_settings/app_settings.dart';
import 'package:sixcomputer/src/widget/sign_in/sign_in_view.dart';

import 'src/app.dart';
import 'src/widget/settings/settings_controller.dart';
import 'src/widget/settings/settings_service.dart';

void main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  //firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  await appPreference.init();

  print('isLogin: ${AppSettings.getIsLogin()}');

  if (AppSettings.getIsLogin()) {
    AppSettings.showTabbar();
  } else {
    navigatorKey.currentState?.pushReplacementNamed(SignInAdminView.routeName);
  }

  FlutterNativeSplash.remove();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));


}

