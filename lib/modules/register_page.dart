import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger/modules/home_page.dart';
import 'package:messenger/providers/user_provider.dart';
import 'package:messenger/utils/services/graphql.dart';
import 'package:messenger/utils/services/shared_preferences.dart';
import 'package:messenger/widgets/email_text_form_field.dart';
import 'package:messenger/widgets/password_text_form_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  static final route = '/register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() != true) return;

    try {
      final loginOutput = await Mutations.register(
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
      );

      if (!mounted) return;

      await Prefs.setToken(loginOutput.jwt);

      Provider.of<UserProvider>(context, listen: false).user = loginOutput.user;

      Navigator.of(context).pushReplacementNamed(HomePage.route);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text('An error occurred.'),
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

  void _back() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messenger')),
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
                            'Register',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            focusNode: _firstNameFocusNode,
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First name',
                              icon: const Icon(Icons.person),
                            ),
                            validator: (value) {
                              if ((value ?? '').length < 2)
                                return 'Invalid first name';
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            focusNode: _lastNameFocusNode,
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last name',
                              icon: const Icon(Icons.person),
                            ),
                            validator: (value) {
                              if ((value ?? '').length < 2)
                                return 'Invalid last name';
                            },
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
                            child: const Text('Go back'),
                            onPressed: _back,
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
