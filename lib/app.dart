import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacyApp/screens/splash_screen.dart';
import 'package:pharmacyApp/styles/theme.dart';

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetMaterialApp(
        title: 'Pharmacy App',
        navigatorKey: navigatorKey,
        theme: themeData,
        home: SplashScreen(),
      ),
    );
  }
}
