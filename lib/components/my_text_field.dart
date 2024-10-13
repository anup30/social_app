import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int maxLines;
  final int maxLength;
  final FocusNode? focusNode;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText=false,
    this.maxLines=1,
    this.maxLength=100,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
