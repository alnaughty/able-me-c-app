import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class FullScreenLoader extends StatefulWidget {
  const FullScreenLoader({Key? key, this.size, this.showText = true})
      : super(key: key);
  final double? size;
  final bool showText;
  @override
  State<FullScreenLoader> createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<FullScreenLoader> with ColorPalette {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: "splash",
            child: Image.asset(
              "assets/images/logo.png",
              gaplessPlayback: true,
              isAntiAlias: true,
              width: widget.size ?? size.width * .4,
              fit: BoxFit.fitWidth,
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .rotate(duration: 2000.ms),
          ),
          if (widget.showText) ...{
            const Gap(30),
            Column(
              children: [
                Text(
                  "ABLE ME",
                  style: context.fontTheme.displayLarge!.copyWith(
                    color: purplePalette,
                    fontFamily: "Lokanova",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Inclusive Transportation",
                  style: context.fontTheme.bodyLarge!.copyWith(
                      color: textColor.withOpacity(.5),
                      fontFamily: "Montserrat"),
                )
              ],
            )
                .animate(
                  delay: const Duration(milliseconds: 2000),
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .fade(
                  duration: const Duration(milliseconds: 2000),
                )
                .scale()
          },
        ],
      ),
    );
  }
}
