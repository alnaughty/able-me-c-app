import 'package:able_me/helpers/context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageBuilder extends StatefulWidget {
  const CustomImageBuilder({
    super.key,
    required this.avatar,
    required this.placeHolderName,
    this.size = 45,
  });
  final String? avatar;
  final String placeHolderName;
  final double size;
  @override
  State<CustomImageBuilder> createState() => _CustomImageBuilderState();
}

class _CustomImageBuilderState extends State<CustomImageBuilder> {
  late final double size = widget.size;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: Container(
        width: size,
        height: size,
        color: widget.avatar == null
            ? context.theme.colorScheme.background
            : Colors.white,
        child: widget.avatar == null
            ? Center(
                child: Text(
                  widget.placeHolderName.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.fontTheme.bodyLarge!.fontSize! + 5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: widget.avatar!,
                height: size,
                width: size,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
