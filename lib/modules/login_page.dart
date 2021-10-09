import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger/utils/data_validator.dart';
import 'package:messenger/utils/services/graphql.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static final route = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState?.validate() == false) return;

    try {
      final loginOutput = await Mutations.login(
        password: _passwordController.text,
        email: _emailController.text,
      );

      // TODO: add providers

    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text('Invalid login credentials'),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _register() async {
    // TODO: register
  }

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
                            size: const Size.square(24),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(const Size.fromWidth(480)),
                child: Form(
                  key: _formKey,
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 16,
                            bottom: 8,
                          ),
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            focusNode: _emailFocusNode,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              icon: const Icon(Icons.mail),
                            ),
                            validator: (value) {
                              if (!Datavalidator.isEmail(value ?? ''))
                                return 'Invalid email';
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            obscureText: true,
                            focusNode: _passwordFocusNode,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              icon: const Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if ((value ?? '').length < 4)
                                return 'Invalid password';
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 12,
                            right: 12,
                            bottom: 2,
                          ),
                          child: ElevatedButton(
                            child: const Text('Login'),
                            onPressed: _login,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 2,
                            left: 12,
                            right: 12,
                            bottom: 12,
                          ),
                          child: ElevatedButton(
                            child: const Text('Register'),
                            onPressed: _register,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
