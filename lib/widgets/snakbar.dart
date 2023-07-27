import 'package:flutter/material.dart';

showSnakBar(String contexts, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(contexts)));
}
