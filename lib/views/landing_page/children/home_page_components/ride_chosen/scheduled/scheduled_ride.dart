import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
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
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/scheduled/able_me_calendar_picker.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ScheduledRide extends ConsumerStatefulWidget {
  const ScheduledRide({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduledRideState();
}

class _ScheduledRideState extends ConsumerState<ScheduledRide>
    with ColorPalette {
  bool isLoading = false;

  late PickupAndDestMap map = PickupAndDestMap(
    destination: null,
    pickUpLocation: pickUpLocation,
    size: context.csize!.height * .55,
  );
  DateTime pickupDateTime = DateTime.now().add(1.days);
  late GeoPoint pickUpLocation = GeoPoint(
    ref.watch(coordinateProvider)!.latitude,
    ref.watch(coordinateProvider)!.longitude,
  );
  bool wheelChairFriendly = true;
  bool withPet = false;
  GeoPoint? dest;
  TimeOfDay? pickupTime;
  int passengerCount = 1;
  int luggageCount = 0;
  final GlobalKey<DestinationPickerState> _kDest =
      GlobalKey<DestinationPickerState>();
  final GlobalKey<DepartureAndMiscState> _kDeptMisc =
      GlobalKey<DepartureAndMiscState>();
  // final GlobalKey<AdditionalInstructionsState> _kInstruction =
  //     GlobalKey<AdditionalInstructionsState>();
  double price = 0.0;
  String? note;
  Future<void> book(List<Instruction> instructs) async {
    final UserModel? user = ref.watch(currentUser);
    // assert(user == null || (dest == null || pickupTime == null),
    //     "one of the required values is left unassigned");
    if (user == null || (dest == null || pickupTime == null)) return;

    setState(() {
      isLoading = true;
    });
    final BookingPayload payload = BookingPayload(
        userID: user.id,
        type: 5,
        transpoType: 2,
        passengers: passengerCount,
        luggage: luggageCount,
        additionalInstructions: instructs,
        departureTime: pickupTime!,
        departureDate: pickupDateTime,
        destination: dest!,
        pickupLocation: pickUpLocation,
        isWheelchairFriendly: wheelChairFriendly,
        price: price,
        withPet: withPet,
        note: note);
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

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    final Size size = context.csize!;
    final UserModel? user = ref.watch(currentUser);
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
                          title: Text("Hello ${user!.name.capitalizeWords()},"),
                          titleTextStyle: TextStyle(
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            height: 1,
                            color: textColor,
                          ),
                          subtitle: const Text(
                            "Let's schedule your ride!",
                          ),
                          subtitleTextStyle: TextStyle(
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: purplePalette,
                            child: CustomImageBuilder(
                              avatar: user.avatar == "" || user.avatar == "null"
                                  ? null
                                  : user.avatar,
                              placeHolderName: user.fullname[0],
                              size: 60,
                            ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
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
                                initDate: DateTime.now().add(1.days),
                                onNoteCallback: (n) {
                                  setState(() {
                                    note = n;
                                  });
                                },
                                onDateCallback: (d) {
                                  setState(() {
                                    pickupDateTime = d;
                                  });
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
                              const SafeArea(
                                top: false,
                                child: SizedBox(
                                  height: 20,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
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
