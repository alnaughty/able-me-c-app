import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/models/rider_booking/booking_data.dart';
import 'package:able_me/models/rider_booking/instruction.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/departure_and_misc.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/destination_picker.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/pickup_and_destination_map.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/ride_chosen_children/additional_instructions.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HourlyRidePage extends ConsumerStatefulWidget {
  const HourlyRidePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HourlyRidePageState();
}

class _HourlyRidePageState extends ConsumerState<HourlyRidePage>
    with ColorPalette {
  bool isLoading = false;
  late PickupAndDestMap map = PickupAndDestMap(
    destination: null,
    pickUpLocation: pickUpLocation,
    size: context.csize!.height * .55,
  );
  bool wheelChairFriendly = true;
  TimeOfDay? pickupTime;
  int passengerCount = 1;
  int luggageCount = 0;
  String? note;
  double price = 0.0;
  final DateTime pickupDateTime = DateTime.now();
  late GeoPoint pickUpLocation = GeoPoint(
      ref.watch(coordinateProvider)!.latitude,
      ref.watch(coordinateProvider)!.longitude);
  GeoPoint? dest;
  bool withPet = false;
  final GlobalKey<AdditionalInstructionsState> _kInstruction =
      GlobalKey<AdditionalInstructionsState>();
  Future<void> book(List<Instruction> instructs) async {
    final UserModel? user = ref.watch(currentUser);
    if (user == null || (dest == null || pickupTime == null)) return;

    setState(() {
      isLoading = true;
    });
    final BookingPayload payload = BookingPayload(
      userID: user.id,
      type: 5,
      transpoType: 2,
      note: note,
      passengers: passengerCount,
      withPet: withPet,
      luggage: luggageCount,
      additionalInstructions: instructs,
      departureTime: pickupTime!,
      departureDate: pickupDateTime,
      destination: dest!,
      isWheelchairFriendly: wheelChairFriendly,
      pickupLocation: pickUpLocation,
      price: price,
    );
    await payload.book().then((val) {
      isLoading = false;
      if (mounted) setState(() {});
      if (val) {
        context.pop();
        return;
      }
    });
    return;
  }

  final GlobalKey<DestinationPickerState> _kDest =
      GlobalKey<DestinationPickerState>();
  final GlobalKey<DepartureAndMiscState> _kDeptMisc =
      GlobalKey<DepartureAndMiscState>();
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    final Size size = context.csize!;
    return PopScope(
      canPop: !isLoading,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned.fill(
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar.large(
                      leadingWidth: 80,
                      leading: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: BackButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) =>
                                            purplePalette.withOpacity(.8)),
                                shape: MaterialStateProperty.resolveWith(
                                    (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6)))),
                            color: Colors.white,
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              }
                            },
                          ),
                        ),
                      ),
                      flexibleSpace: map,
                      expandedHeight: size.height * .51,
                      collapsedHeight: size.height * .3,
                    ),
                    SliverList.list(
                      children: [
                        const Gap(15),
                        Center(
                          child: Container(
                            width: size.width * .15,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? bgColor.lighten()
                                  : bgColor.darken(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text("Book a ride ahead,"),
                          titleTextStyle: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            height: 1,
                            color: textColor,
                          ),
                          subtitle: const Text(
                            "Timely Rides at Your Convenience!",
                          ),
                          subtitleTextStyle: TextStyle(
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (dest != null) ...{
                          Divider(
                            color: textColor.withOpacity(.2),
                          ),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Distance",
                                  style: TextStyle(
                                    color: textColor.withOpacity(1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${dest!.distanceBetweenPoints(pickUpLocation).toStringAsFixed(1)} KM",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // ignore: equal_elements_in_set
                          const Gap(20),
                          Divider(
                            color: textColor.withOpacity(.2),
                          ),
                        },
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (dest != null) ...{
                                Divider(
                                  color: textColor.withOpacity(.2),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Distance",
                                      style: TextStyle(
                                        color: textColor.withOpacity(1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${dest!.distanceBetweenPoints(pickUpLocation).toStringAsFixed(1)} KM",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                  color: textColor.withOpacity(.2),
                                ),
                              },
                              DestinationPicker(
                                key: _kDest,
                                onDestinationCallback: (g) {
                                  setState(() {
                                    dest = g;
                                    map = PickupAndDestMap(
                                      key: Key("${g.latitude},${g.longitude}"),
                                      destination: dest,
                                      pickUpLocation: pickUpLocation,
                                      size: context.csize!.height * .56,
                                    );
                                  });
                                },
                                onPickupcallback: (g) {
                                  setState(() {
                                    pickUpLocation = g;
                                    map = PickupAndDestMap(
                                      key: Key("${g.latitude},${g.longitude}"),
                                      destination: dest,
                                      pickUpLocation: pickUpLocation,
                                      size: context.csize!.height * .56,
                                    );
                                  });
                                },
                              ),
                              const Gap(20),
                              DepartureAndMisc(
                                key: _kDeptMisc,
                                initDate: DateTime.now(),
                                onNoteCallback: (n) {
                                  setState(() {
                                    note = n;
                                  });
                                },
                                dateEditable: false,
                                onDateCallback: (d) {
                                  // setState(() {
                                  //   pickupDateTime = d;
                                  // });
                                },
                                onTimeCallback: (t) {
                                  setState(() {
                                    pickupTime = t;
                                  });
                                },
                                withPetCallback: (b) {
                                  setState(() {
                                    withPet = b;
                                  });
                                },
                                wheelChairFriendlyCallback: (b) {
                                  setState(() {
                                    wheelChairFriendly = b;
                                  });
                                },
                                budgetCallback: (i) {
                                  setState(() {
                                    price = i;
                                  });
                                },
                                passengerCallback: (i) {
                                  setState(() {
                                    passengerCount = i;
                                  });
                                },
                                luggageCallback: (i) {
                                  setState(() {
                                    luggageCount = i;
                                  });
                                },
                              ),
                              const Gap(20),
                              MaterialButton(
                                height: 60,
                                color: purplePalette,
                                onPressed: () async {
                                  final bool isDestGood =
                                      _kDest.currentState!.isValidated();
                                  final bool isDeptGood =
                                      _kDeptMisc.currentState!.isValidated();
                                  if (isDestGood && isDeptGood) {
                                    print("GOOD");
                                    await book([]);
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
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading) ...{
              Positioned.fill(
                child: Container(
                    color: Colors.black.withOpacity(.5),
                    child: Center(
                      child: SizedBox(
                        height: size.height * .4,
                        child: FullScreenLoader(
                          showText: false,
                          size: size.width * .2,
                        ),
                      ),
                    )),
              )
            }
          ],
        ),
      ),
    );
  }
}
