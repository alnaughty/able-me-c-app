import 'package:able_me/helpers/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class FullScreenLoader extends StatefulWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  State<FullScreenLoader> createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<FullScreenLoader> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
              width: size.width * .4,
              fit: BoxFit.fitWidth,
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .rotate(duration: 2000.ms),
          ),
          const Gap(30),
          Column(
            children: [
              Text(
                "ABLE ME",
                style: context.fontTheme.headlineLarge!.copyWith(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Inclusive Transportation",
                style: context.fontTheme.bodyLarge!.copyWith(
                  color: Colors.grey.shade600,
                ),
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
        ],
      ),
    );
  }
}
