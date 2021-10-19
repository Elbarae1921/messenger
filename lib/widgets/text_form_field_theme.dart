import 'package:flutter/material.dart';
import 'package:messenger/constants/extended_colors.dart';

class TextFormFieldTheme extends StatelessWidget {
  const TextFormFieldTheme({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: ExtendedColors.spaceCadet.shade100,
            ),
      ),
      child: child,
    );
  }
}
