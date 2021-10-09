import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger/constants/extended_colors.dart';
import 'package:messenger/modules/splash_page.dart';
import 'package:messenger/providers/user_provider.dart';
import 'package:messenger/utils/services/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static final route = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messenger')),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        final version = data?.version;
                        final appName = data?.appName;

                        if (snapshot.connectionState == ConnectionState.done)
                          return Column(
                            children: [
                              Text(appName!),
                              Text(
                                version!,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          );
                        else
                          return Center(
                            child: SizedBox.fromSize(
                              size: const Size.square(24),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                      },
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, value, child) {
                      return Text('Hello, ${value.user!.fullName}');
                    },
                  ),
                ],
              ),
            ),
            ListTileTheme(
              iconColor: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                children: [
                  ListTile(
                    // TODO: add profile
                    title: const Text('Profile'),
                    leading: const Icon(Icons.person),
                    enabled: false,
                  ),
                  ListTile(
                    // TODO: add friends
                    title: const Text('Friends'),
                    leading: const Icon(Icons.people),
                    enabled: false,
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    leading: const Icon(Icons.logout),
                    onTap: () async {
                      await Prefs.setToken(null);

                      Navigator.of(context)
                          .pushReplacementNamed(SplashPage.route);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: const Center(child: const Text('Home')),
    );
  }
}
