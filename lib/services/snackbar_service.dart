import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: const EdgeInsets.all(15),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.grey,
    content: Text(message),
  ));
}
