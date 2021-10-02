import 'package:flutter/material.dart';
import 'package:messenger/constants/extended_colors.dart';
import 'package:messenger/modules/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = ThemeData.dark().textTheme.apply(fontFamily: 'Ubuntu');
    final appTheme = ThemeData.dark().copyWith(
      textTheme: textTheme,
      accentTextTheme: textTheme,
      primaryTextTheme: textTheme,
      primaryColor: ExtendedColors.spaceCadet,
    );

    return MaterialApp(
      theme: appTheme,
      title: 'Messenger',
      home: HomeScreen(),
      darkTheme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
