import 'package:flutter/material.dart';
import 'package:watherapp/screen/home/home_screen.dart';

class RouteNames {
  // static const String animatedSplashScreen = '/';
  static const String homePage = '/homePage';

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case RouteNames.homePage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HomeScreen());

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
