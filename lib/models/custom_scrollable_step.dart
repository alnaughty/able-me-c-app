import 'package:flutter/material.dart';

class ScrollableStep {
  const ScrollableStep({
    required this.title,
    this.subtitle,
    required this.content,
    this.isActive = false,
    this.label,
  });
  final Widget title;
  final Widget? subtitle;
  final Widget content;
  final bool isActive;
  final Widget? label;
}
