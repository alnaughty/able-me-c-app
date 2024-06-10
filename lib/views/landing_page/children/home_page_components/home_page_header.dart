import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/firebase_user_location_model.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/notifiers/user_location_state_notifier.dart';
import 'package:able_me/views/landing_page/children/home_page_components/choose_ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class HomeHeader extends ConsumerStatefulWidget {
  const HomeHeader({super.key});

  @override
  ConsumerState<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends ConsumerState<HomeHeader> with ColorPalette {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return Container(
      width: double.infinity,
      height: size.height * .6,
      color: bgColor,
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: LayoutBuilder(builder: (context, c) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: c.maxHeight * .75,
              decoration: BoxDecoration(
                color: purplePalette,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // const ChooseService(),
                  const ChooseRide(),
                  Consumer(
                    builder: ((context, ref, child) {
                      final Position? pos = ref.watch(coordinateProvider);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        // color: Colors.red,
                        child: Card(
                            color: context.theme.cardColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Pickup Location",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      textColor.withOpacity(.5),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const Gap(5),
                                            if (pos != null) ...{
                                              FutureBuilder(
                                                  future: Geocoder.google()
                                                      .findAddressesFromCoordinates(
                                                    Coordinates(pos.latitude,
                                                        pos.longitude),
                                                  ),
                                                  builder: (_, f) {
                                                    final List<GeoAddress>
                                                        currentAddress =
                                                        f.data ?? [];
                                                    if (currentAddress
                                                        .isEmpty) {
                                                      return Container();
                                                    }
                                                    return Text(
                                                      currentAddress.first
                                                              .addressLine ??
                                                          "",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    );
                                                  })
                                            }
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/images/mockup_vectors/location.png",
                                        height: 90,
                                        fit: BoxFit.fitHeight,
                                      )
                                          .animate()
                                          .fadeIn(duration: 1000.ms)
                                          .slideX(begin: 1, end: 0)
                                    ],
                                  ),
                                ),
                                Consumer(
                                  builder: (_, ref, child) {
                                    final List<FirebaseUserLocation> data =
                                        ref.watch(userLocationProvider);
                                    return Column(
                                      children: [
                                        Divider(
                                          color: textColor.withOpacity(.3),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${data.length} driver${data.length > 1 ? "s" : ""} nearby",
                                                style: TextStyle(
                                                  color:
                                                      textColor.withOpacity(1),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: Text(
                                                  "View All",
                                                  style: TextStyle(
                                                    color: purplePalette,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Gap(10)
                                      ],
                                    );
                                  },
                                )
                              ],
                            )),
                      );
                    }),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
