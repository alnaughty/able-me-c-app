import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BrowseRestaurantsDisplay extends StatefulWidget {
  const BrowseRestaurantsDisplay({super.key});

  @override
  State<BrowseRestaurantsDisplay> createState() =>
      _BrowseRestaurantsDisplayState();
}

class _BrowseRestaurantsDisplayState extends State<BrowseRestaurantsDisplay>
    with ColorPalette {
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final double bundleSize = context.csize!.width * .45;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: bundleSize,
                height: bundleSize * 1.1,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned(
                      top: 10,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          "assets/images/mockup_vectors/Fries.png",
                          width: bundleSize * .6,
                        )
                            .animate(
                              onComplete: (c) {
                                // c.repeat();
                                // c.reverse();
                                c.loop(reverse: true);
                              },
                              onInit: (c) {},
                              autoPlay: true,
                            )
                            .moveY(duration: 800.ms),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Center(
                        child: Image.asset(
                          "assets/images/mockup_vectors/Soda.png",
                          width: bundleSize * .35,
                        ).animate(
                          onComplete: (c) {
                            // c.repeat();
                            // c.reverse();
                            c.loop(reverse: true);
                          },
                        ).move(duration: 1000.ms),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Center(
                        child: Image.asset(
                          "assets/images/mockup_vectors/Hamburger.png",
                          width: bundleSize * .7,
                        ).animate(
                          onComplete: (c) {
                            // c.repeat();
                            // c.reverse();
                            c.loop(reverse: true);
                          },
                        ).moveX(duration: 900.ms),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms)
                  .slideY(begin: 1, end: 0, duration: 1000.ms),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Consumer(
                      builder: (_, ref, child) {
                        final bool isDarkMode = ref.watch(darkModeProvider);
                        return Text(
                          "Craving something?".capitalizeWords(),
                          style: TextStyle(
                            color: purplePalette.lighten(isDarkMode ? .2 : 0),
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            height: 1,
                          ),
                        );
                      },
                    ),
                    const Gap(5),
                    Text(
                      "Order food from our partner restaurants, and enjoy!"
                          .capitalizeWords(),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                    const Gap(20),
                    MaterialButton(
                      onPressed: () {
                        context.push('/browse-restaurants');
                      },
                      color: purplePalette,
                      height: 45,
                      child: const Center(
                        child: Text(
                          "BROWSE",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )
                    .animate()
                    .fadeIn(duration: 1000.ms)
                    .slideX(duration: 1000.ms, begin: 1, end: 0),
              )
            ],
          ),
        )
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "Feeling Hungry?".capitalizeWords(),
        //         style: TextStyle(
        //           color: !context.isDarkMode ? textColor : purplePalette,
        //           fontWeight: FontWeight.w800,
        //           fontSize: 20,
        //         ),
        //       )
        //           .animate()
        //           .fadeIn(duration: 1000.ms)
        //           .slideY(begin: 1, end: 0, duration: 1000.ms),
        //       Text(
        //         "Order foods from our partner restaurants",
        //         style: TextStyle(
        //           color: textColor,
        //         ),
        //       )
        //           .animate()
        //           .fadeIn(duration: 1000.ms)
        //           .slideY(begin: 1, end: 0, duration: 1000.ms),
        //     ],
        //   ),
        // ),
        // Container(
        //   height: 120,
        //   color: Colors.red,
        //   width: double.infinity,
        //   child: ListView(
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     scrollDirection: Axis.horizontal,
        //     children: [
        //       Text(
        //         "asdads",
        //         style: TextStyle(color: Colors.red),
        //       )
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
