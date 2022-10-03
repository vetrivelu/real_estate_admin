import 'package:flutter/material.dart';

class FormTester extends StatelessWidget {
  const FormTester({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(flex: 2, child: child),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }
}

TextTheme getText(context) => Theme.of(context).textTheme;
