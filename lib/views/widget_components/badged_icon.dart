import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BadgedIcon extends StatefulWidget {
  const BadgedIcon(
      {super.key,
      required this.isBadged,
      required this.iconPath,
      this.iconSize = 20});
  final bool isBadged;
  final String iconPath;
  final double iconSize;
  @override
  State<BadgedIcon> createState() => _BadgedIconState();
}

class _BadgedIconState extends State<BadgedIcon> with ColorPalette {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            widget.iconPath,
            width: widget.iconSize,
            color: context.theme.secondaryHeaderColor,
          ),
        ),
        if (widget.isBadged) ...{
          Positioned(
            top: 8,
            right: 8,
            child: Badge(
              smallSize: 10,
              backgroundColor: context.theme.colorScheme.primary,
            ),
          )
        },
      ],
    );
  }
}
