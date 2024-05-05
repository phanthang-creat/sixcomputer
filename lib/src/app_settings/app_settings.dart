import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sixcomputer/src/app.dart';
import 'package:sixcomputer/src/app_settings/app_preference.dart';
import 'package:sixcomputer/src/widget/tabbar/tabbar.dart';

class AppSettings {

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static bool getIsLogin() {
    final value = appPreference.getData('isLogin');
    return value != null && value == 'true';
  }

  static void setIsLogin(String value) {
    appPreference.setData('isLogin', value.toString());
  }

  static showTabbar() {
    navigatorKey.currentState?.popUntil((route) {
      if (route.isFirst) {
        if (route.settings.name != TabbarController.routeName) {
          navigatorKey.currentState
              ?.pushReplacementNamed(TabbarController.routeName);
        }
        return true;
      } else {
        return false;
      }
    });
  }
}