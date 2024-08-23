import 'package:flutter/material.dart';

void ShowSnackBar(BuildContext context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1, milliseconds: 200),
      content: Center(child: Text(text)),
    ),
  );
}
