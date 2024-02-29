import 'package:flutter/material.dart';

class ContentAndAction {
  final String title;
  final Function()? onPressed;
  final Widget icon;

  const ContentAndAction(
      {required this.icon, required this.onPressed, required this.title});
}
