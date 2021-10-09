import 'dart:ui';

import 'package:flutter/material.dart';
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
        final user = await Queries.me();

        Provider.of<UserProvider>(context, listen: false).user = user;

        // TODO: main page
        // Navigator.of(context).pushReplacementNamed()
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
