import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/category.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/app_src/transpo_assitance.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/notifiers/user_location_state_notifier.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/departure_and_misc.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/destination_picker.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/new_booking_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class MainTransportationPage extends ConsumerStatefulWidget {
  const MainTransportationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      MainTransportationPageState();
}

class MainTransportationPageState extends ConsumerState<MainTransportationPage>
    with ColorPalette, TranspoAssistance {
  final GlobalKey<DestinationPickerState> _kDest =
      GlobalKey<DestinationPickerState>();
  final GlobalKey<DepartureAndMiscState> _kDeptMisc =
      GlobalKey<DepartureAndMiscState>();
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
  late final List<Widget> _contents = [
    Expanded(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: context.theme.cardColor,
        padding: const EdgeInsets.all(15),
        onPressed: () async {
          // await onTap(2);
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
          // await onTap(3);
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initTransportPlatform((t) {
        print("VAL : $t");
      });
    });
    // TODO: implement didChangeDependencies
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final Position? pos = ref.watch(coordinateProvider);
    final UserModel? _udata = ref.watch(currentUser.notifier).state;
    final Size size = context.csize!;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            // height: size.width * 1.2,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                purplePalette,
                bgColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(65),
                  child: AppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      // leading: _udata != null
                      //     ? Container(
                      //         width: 70,
                      //       )
                      //     : null,
                      leadingWidth: 90,
                      leading: _udata != null
                          ? Center(
                              child: CustomImageBuilder(
                                avatar: _udata.avatar,
                                placeHolderName: _udata.name[0].toUpperCase(),
                              ),
                            )
                          : null,
                      // if (_udata != null) ...{
                      // CustomImageBuilder(
                      //   avatar: _udata.avatar,
                      //   placeHolderName: _udata.name[0].toUpperCase(),
                      // ),
                      //   const Gap(10)
                      // },
                      actions: [
                        IconButton(
                            tooltip: "History & Transactions",
                            onPressed: () {},
                            icon: const Icon(
                              Icons.receipt_long,
                              color: Colors.white,
                            )),
                        if (_udata != null) ...{
                          Container(
                            width: 5,
                          )
                        },
                      ],
                      title: pos == null
                          ? Text(
                              "Unknown Location",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: textColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            )
                          : FutureBuilder(
                              future: Geocoder.google()
                                  .findAddressesFromCoordinates(
                                Coordinates(pos.latitude, pos.longitude),
                              ),
                              builder: (_, f) {
                                final List<GeoAddress> currentAddress =
                                    f.data ?? [];

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/location.svg",
                                      color: Colors.white,
                                      width: 20,
                                    ),
                                    const Gap(5),
                                    if (currentAddress.isEmpty) ...{
                                      const Text(
                                        "Unknown Location",
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700),
                                      )
                                    } else ...{
                                      Text(
                                        "${currentAddress.first.locality}, ${currentAddress.first.countryCode}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: "Montserrat",
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    },
                                  ],
                                );
                              })),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello ${_udata?.name.capitalizeWords() ?? ""}!",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          color: Colors.white.withOpacity(1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        "Let's book your next trip!",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(30),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: bgColor.lighten(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: NewBookingViewer(
                          destK: _kDest,
                          deptMiscK: _kDeptMisc,
                          onPayloadCreated: (payload) {},
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Gap(0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: MaterialButton(
              height: 60,
              color: purplePalette,
              onPressed: () async {
                final bool isDestGood = _kDest.currentState!.isValidated();
                final bool isDeptGood = _kDeptMisc.currentState!.isValidated();
                if (isDestGood && isDeptGood) {
                  print("GOOD");
                  // await book([]);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SafeArea(
            child: SizedBox(
              height: 20,
            ),
          )
        ],
      ),
    );
  }
}
