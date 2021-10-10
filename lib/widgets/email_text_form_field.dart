import 'package:flutter/material.dart';
import 'package:messenger/utils/data_validator.dart';
import 'package:messenger/widgets/text_form_field_theme.dart';

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    Key? key,
    required this.focusNode,
    required this.textEditingController,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldTheme(
      child: TextFormField(
        focusNode: focusNode,
        controller: textEditingController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email',
          icon: const Icon(Icons.mail),
        ),
        validator: (value) {
          if (!Datavalidator.isEmail(value ?? '')) return 'Invalid email';
        },
      ),
    );
  }
}
