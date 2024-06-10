import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BrowsePharmacyViewer extends StatefulWidget {
  const BrowsePharmacyViewer({super.key});

  @override
  State<BrowsePharmacyViewer> createState() => _BrowsePharmacyViewerState();
}

class _BrowsePharmacyViewerState extends State<BrowsePharmacyViewer>
    with ColorPalette {
  final double height = 170;
  @override
  Widget build(BuildContext context) {
    final Size size = context.csize!;
    final Color bgColor = context.theme.cardColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: bgColor,
                child: InkWell(
                  onTap: () {
                    context.push('/browse-pharmacies');
                  },
                  radius: 20,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: height * .7,
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer(
                          builder: (_, ref, child) {
                            final bool isDarkMode = ref.watch(darkModeProvider);
                            return Text(
                              "Medicines?\nWe Got You!",
                              style: TextStyle(
                                color: !isDarkMode
                                    ? purplePalette
                                    : purplePalette.lighten(),
                                fontSize: 20,
                                height: 1,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                        const Gap(5),
                        Text(
                          "Checkout our pharmacies\naround you!",
                          style: TextStyle(
                              color: textColor, fontSize: 12, height: 1),
                        )
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 1000.ms)
                        .slideX(duration: 1000.ms),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Image.asset("assets/images/mockup_vectors/Medicine Box.png")
                .animate()
                .slideX(begin: 1, end: 0, duration: 1000.ms)
                .fadeIn(duration: 1000.ms),
          )
        ],
      ),
    );
  }
}
