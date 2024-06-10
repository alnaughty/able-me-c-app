import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/firebase_user_location_model.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/notifiers/user_location_state_notifier.dart';
import 'package:able_me/views/landing_page/children/home_page_components/eta_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class QuickRidePage extends ConsumerStatefulWidget {
  const QuickRidePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuickRidePageState();
}

class _QuickRidePageState extends ConsumerState<QuickRidePage>
    with ColorPalette {
  @override
  Widget build(BuildContext context) {
    final Position? pos = ref.watch(coordinateProvider);
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final List<FirebaseUserLocation> data = ref.watch(userLocationProvider);
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: data.isEmpty
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "NO NEARBY DRIVER FOUND!",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Gap(20),
                    MaterialButton(
                      color: purplePalette,
                      onPressed: () {},
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Book a ride later",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      "Choose driver",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const Gap(20),
                    ...data.map(
                      (e) => MaterialButton(
                        padding: const EdgeInsets.all(20),
                        onPressed: () async {
                          context.push("/rider-details-page/${e.id}/1");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        // padding: const Edge,
                        color: context.isDarkMode
                            ? bgColor.lighten(.05)
                            : bgColor.darken(.05),
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.fullname.capitalizeWords(),
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Active ${timeago.format(e.lastActive.toDate())}",
                                      style: TextStyle(
                                        color: purplePalette,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const Gap(10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor:
                                              textColor.withOpacity(.5),
                                        ),
                                        const Gap(10),
                                        ETAWidget(
                                          riderPoint: e.coordinates,
                                          additionalText: "away",
                                          style: TextStyle(
                                            color: textColor.withOpacity(
                                              .5,
                                            ),
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              CustomImageBuilder(
                                avatar: e.avatar == "" || e.avatar == "null"
                                    ? null
                                    : e.avatar,
                                placeHolderName: e.fullname[0],
                                size: 60,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
