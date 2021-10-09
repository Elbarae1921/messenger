import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger/modules/home_page.dart';
import 'package:messenger/modules/register_page.dart';
import 'package:messenger/providers/user_provider.dart';
import 'package:messenger/utils/services/graphql.dart';
import 'package:messenger/utils/services/shared_preferences.dart';
import 'package:messenger/widgets/email_text_form_field.dart';
import 'package:messenger/widgets/password_text_form_field.dart';
import 'package:provider/provider.dart';

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
    if (_formKey.currentState?.validate() != true) return;

    try {
      final loginOutput = await Mutations.login(
        password: _passwordController.text,
        email: _emailController.text,
      );

      if (!mounted) return;

      await Prefs.setToken(loginOutput.jwt);

      await Prefs.setAutoEmail(_emailController.text);

      Provider.of<UserProvider>(context, listen: false).user = loginOutput.user;

      Navigator.of(context).pushReplacementNamed(HomePage.route);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text('Invalid login credentials.'),
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

  void _register() async {
    Navigator.of(context).pushNamed(RegisterPage.route);
  }

  Future<void> _forgot() async {
    await showDialog(
      context: context,
      builder: (context) {
        return ForgotPasswordDialog(email: _emailController.text);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final email = await Prefs.getAutoEmail();

      if (email != null) _emailController.text = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messenger')),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
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
                          child: EmailTextFormField(
                            focusNode: _emailFocusNode,
                            textEditingController: _emailController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PasswordTextFormField(
                            focusNode: _passwordFocusNode,
                            textEditingController: _passwordController,
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
                            bottom: 2,
                          ),
                          child: ElevatedButton(
                            child: const Text('Register'),
                            onPressed: _register,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 2,
                            left: 12,
                            right: 12,
                            bottom: 8,
                          ),
                          child: TextButton(
                            child: const Text('💀 Forgor'),
                            onPressed: _forgot,
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

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailFocusNode = FocusNode();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _send() async {
    // TODO: forgot password

    if (_formKey.currentState?.validate() != true) return;

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3,
        sigmaY: 3,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.fromWidth(480)),
          child: Dialog(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 8,
                    ),
                    child: Text(
                      'Recover password',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 8,
                    ),
                    child: Text(
                      'We\'ll send a recovery link to the account associated to this email.',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: EmailTextFormField(
                      focusNode: _emailFocusNode,
                      textEditingController: _emailController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 12,
                      right: 12,
                      bottom: 8,
                    ),
                    child: ElevatedButton(
                      child: const Text('Send'),
                      onPressed: _send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
