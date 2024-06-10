import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/rider_booking/category.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/quick_ride_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ChooseRide extends ConsumerStatefulWidget {
  const ChooseRide({super.key});

  @override
  ConsumerState<ChooseRide> createState() => _ChooseRideState();
}

class _ChooseRideState extends ConsumerState<ChooseRide> with ColorPalette {
  final List<Category> rideTypes = [
    // const Category(
    //   name: "Quick Ride",
    //   assetImage: "assets/icons/quick.svg",
    //   type: 1,
    // ),
    const Category(
      name: "Hourly",
      assetImage: "assets/images/mockup_vectors/clock.png",
      type: 2,
    ),
    const Category(
      name: "Scheduled",
      assetImage: "assets/images/mockup_vectors/Calendar.png",
      type: 3,
    ),
  ];
  Future<void> onTap(int type) async {
    if (type == 1) {
      await showModalBottomSheet(
        context: context,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const QuickRidePage(),
      );
    } else if (type == 2) {
      await context.push('/hourly-ride-booking');
    } else {
      await context.push('/scheduled-ride-booking');
    }
    return;
  }

  late final List<Widget> _contents = [
    Expanded(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: context.theme.cardColor,
        padding: const EdgeInsets.all(15),
        onPressed: () async {
          await onTap(2);
        },
        child: LayoutBuilder(builder: (context, c) {
          return Row(
            children: [
              Image.asset(
                rideTypes.first.assetImage,
                width: c.maxWidth * .4,
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 1, end: 0, duration: 800.ms),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rideTypes.first.name,
                      style: TextStyle(
                        color: purplePalette
                            .lighten(ref.watch(darkModeProvider) ? .2 : 0),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Book a ride today!",
                      style: TextStyle(
                        color:
                            context.theme.secondaryHeaderColor.withOpacity(.5),
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    ),
    const Gap(15),
    Expanded(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: context.theme.cardColor,
        padding: const EdgeInsets.all(20),
        onPressed: () async {
          await onTap(3);
        },
        child: LayoutBuilder(builder: (context, c) {
          return Row(
            children: [
              Image.asset(
                rideTypes.last.assetImage,
                width: c.maxWidth * .35,
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 1, end: 0, duration: 800.ms),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rideTypes.last.name,
                      style: TextStyle(
                        color: purplePalette
                            .lighten(ref.watch(darkModeProvider) ? .2 : 0),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Book a ride days ahead!",
                      style: TextStyle(
                        color:
                            context.theme.secondaryHeaderColor.withOpacity(.5),
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;

    final bool isDarkMode = ref.watch(darkModeProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose your ride",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Gap(10),
          Row(
            children: _contents,
          ),
          const Gap(15),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: context.theme.cardColor,
            padding: const EdgeInsets.all(20),
            onPressed: () async {
              await onTap(1);
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quick Ride",
                        style: TextStyle(
                          color: purplePalette.lighten(isDarkMode ? .2 : 0),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "Wait no more, you can ride immediately!",
                        style: TextStyle(
                          color: textColor.withOpacity(.5),
                          fontSize: 11,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        "(SUBSCRIBERS ONLY)",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? orange : red,
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(10),
                Image.asset(
                  "assets/images/mockup_vectors/Hourglass.png",
                  width: context.csize!.width * .18,
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideX(begin: 1, end: 0, duration: 800.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
