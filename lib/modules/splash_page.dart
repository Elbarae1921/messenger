import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger/modules/home_page.dart';
import 'package:messenger/modules/login_page.dart';
import 'package:messenger/providers/user_provider.dart';
import 'package:messenger/utils/services/graphql.dart';
import 'package:messenger/utils/services/shared_preferences.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  static final route = '/';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final token = await Prefs.getToken();

      if (token != null) {
        try {
          final user = await Queries.me();

          Provider.of<UserProvider>(context, listen: false).user = user;

          Navigator.of(context).pushReplacementNamed(HomePage.route);
        } catch (e) {
          Navigator.of(context).pushReplacementNamed(LoginPage.route);
        }
      } else
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox.fromSize(
          size: const Size.square(36),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
