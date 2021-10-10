import 'package:flutter/material.dart';
import 'package:messenger/constants/extended_colors.dart';
import 'package:messenger/modules/home_page.dart';
import 'package:messenger/modules/login_page.dart';
import 'package:messenger/modules/register_page.dart';
import 'package:messenger/modules/splash_page.dart';
import 'package:messenger/providers/user_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = ThemeData.dark().textTheme.apply(fontFamily: 'Ubuntu');
    final appTheme = ThemeData.dark().copyWith(
      textTheme: textTheme,
      accentTextTheme: textTheme,
      primaryTextTheme: textTheme,
      primaryColor: ExtendedColors.spaceCadet,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ExtendedColors.darkSlateGray,
      ),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: ExtendedColors.darkSlateGray,
        primarySwatch: ExtendedColors.spaceCadet,
      ),
      textButtonTheme: TextButtonThemeData(style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.any({
            MaterialState.dragged,
            MaterialState.focused,
            MaterialState.hovered,
            MaterialState.pressed,
            MaterialState.selected,
          }.contains)) return ExtendedColors.darkSlateGray.shade100;
          return ThemeData.dark().disabledColor;
        }),
      )),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.any({
          MaterialState.dragged,
          MaterialState.focused,
          MaterialState.hovered,
          MaterialState.pressed,
          MaterialState.selected,
        }.contains)) return ExtendedColors.darkSlateGray;
      })),
    );

    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        theme: appTheme,
        title: 'Messenger',
        darkTheme: appTheme,
        debugShowCheckedModeBanner: false,
        routes: {
          SplashPage.route: (context) => SplashPage(),
          LoginPage.route: (context) => LoginPage(),
          RegisterPage.route: (context) => RegisterPage(),
          HomePage.route: (context) => HomePage(),
        },
      ),
    );
  }
}
