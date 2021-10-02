import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messenger')),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<PackageInfo>(
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
                            size: const Size.square(20),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(64),
          child: Text(
            'Messenger',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
