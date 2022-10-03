import 'package:flutter/material.dart';

class TileFormField extends StatelessWidget {
  const TileFormField({
    Key? key,
    required this.controller,
    required this.title,
    this.maxLines = 1,
    this.onChanged,
    this.keyboardType = TextInputType.multiline,
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final int? maxLines;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          keyboardType: keyboardType,
          inputFormatters: [],
          onChanged: onChanged,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          maxLines: maxLines,
        ),
      ),
    );
  }
}
