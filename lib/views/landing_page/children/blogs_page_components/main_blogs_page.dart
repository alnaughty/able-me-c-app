import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainBlogPage extends ConsumerStatefulWidget {
  const MainBlogPage({super.key});

  @override
  ConsumerState<MainBlogPage> createState() => _MainBlogPageState();
}

class _MainBlogPageState extends ConsumerState<MainBlogPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
