import 'package:flutter/material.dart';
import 'package:messenger/widgets/text_form_field_theme.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    Key? key,
    required this.focusNode,
    required this.textEditingController,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textEditingController;

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _visible = false;

  void _toggleVisible() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldTheme(
      child: TextFormField(
        obscureText: !_visible,
        focusNode: widget.focusNode,
        controller: widget.textEditingController,
        keyboardType: _visible ? TextInputType.visiblePassword : null,
        decoration: InputDecoration(
          labelText: 'Password',
          icon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: _toggleVisible,
            icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
          ),
        ),
        validator: (value) {
          if ((value ?? '').length < 4) return 'Invalid password';
        },
      ),
    );
  }
}
