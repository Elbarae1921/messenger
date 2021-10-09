import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  const PasswordTextFormField({
    Key? key,
    required this.focusNode,
    required this.textEditingController,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      focusNode: focusNode,
      controller: textEditingController,
      decoration: const InputDecoration(
        labelText: 'Password',
        icon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if ((value ?? '').length < 4) return 'Invalid password';
      },
    );
  }
}
