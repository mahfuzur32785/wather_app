import 'package:flutter/material.dart';
import 'package:watherapp/screen/home/home_screen.dart';
import 'package:watherapp/screen/setting/setting_screen.dart';

class RouteNames {
  // static const String animatedSplashScreen = '/';
  static const String homePage = '/homePage';
  static const String settingPage = '/settingPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case RouteNames.homePage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HomeScreen());

      case RouteNames.settingPage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SettingScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
