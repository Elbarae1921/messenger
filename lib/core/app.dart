import 'package:flutter/material.dart';
import 'package:messenger/constants/extended_colors.dart';
import 'package:messenger/modules/login_page.dart';
import 'package:messenger/modules/splash_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = ThemeData.dark().textTheme.apply(fontFamily: 'Ubuntu');
    final appTheme = ThemeData.dark().copyWith(
      textTheme: textTheme,
      accentTextTheme: textTheme,
      primaryTextTheme: textTheme,
      primaryColor: ExtendedColors.spaceCadet,
      colorScheme: ColorScheme.fromSwatch(
        accentColor: ExtendedColors.darkSlateGray,
        primarySwatch: ExtendedColors.spaceCadet,
      ),
    );

    return MaterialApp(
      theme: appTheme,
      title: 'Messenger',
      darkTheme: appTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        SplashPage.route: (context) => SplashPage(),
        LoginPage.route: (context) => LoginPage(),
      },
    );
  }
}
