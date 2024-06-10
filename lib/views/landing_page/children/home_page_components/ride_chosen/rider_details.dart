import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/book_rider_widget_helpers/map_picker.dart';
import 'package:able_me/helpers/widget/book_rider_widget_helpers/wheelchair_friendly.dart';
import 'package:able_me/helpers/widget/image_as_marker.dart';
import 'package:able_me/models/book_rider_details.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/booking_data.dart';
import 'package:able_me/models/rider_booking/instruction.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/api/rider.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/pickup_and_destination_map.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/ride_chosen_children/additional_instructions.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/ride_chosen_children/total_calculator.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RiderDetails extends ConsumerStatefulWidget {
  const RiderDetails({super.key, required this.id, required this.bookingType});
  final int id;
  final int bookingType; // QUICK RIDE = 1, HOURLY = 2, SCHEDULED = 3
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RiderDetailsState();
}

class _RiderDetailsState extends ConsumerState<RiderDetails> with ColorPalette {
  static final RiderApi api = RiderApi();
  final GlobalKey<AdditionalInstructionsState> _kInstruction =
      GlobalKey<AdditionalInstructionsState>();
  int passengerCount = 1;
  int luggageCount = 0;
  DateTime? pickupDateTime;
  GeoPoint? dest;
  late PickupAndDestMap map = PickupAndDestMap(
    destination: null,
    size: context.csize!.height * .55,
  );
  bool isLoading = false;
  // Position pickupLocation;
  String get bookingType {
    if (widget.bookingType == 1) {
      return "Quick Ride";
    } else if (widget.bookingType == 2) {
      return "Hourly";
    }
    return "Scheduled";
  }

  bool wheelChairFriendly = true;
  BookRiderDetails? rider;
  Future<void> book() async {
    final UserModel? user = ref.watch(currentUser);
    // if (user == null || (dest == null || pickupTime == null)) return;
    if (user == null || dest == null) return;
    final Position? mylocation = ref.watch(coordinateProvider);
    if (mylocation == null) return;
    late final double fare = double.parse(
          dest!.distanceBetween(mylocation).toStringAsFixed(2),
        ) *
        rider!.vehicle.fare;
    setState(() {
      isLoading = true;
    });
    bool withPet = false;
    late final double luggageFee = 0.0 * luggageCount;
    late final double convenienceFee = ((fare + luggageFee) * .07);
    final List<Instruction> _ins =
        _kInstruction.currentState?.instructions ?? [];
    final BookingPayload payload = BookingPayload(
      userID: user.id,
      type: 5,
      transpoType: 1,
      riderID: widget.id,
      passengers: passengerCount,
      luggage: luggageCount,
      additionalInstructions: _ins,
      departureTime: TimeOfDay.now(),
      departureDate: DateTime.now(),
      withPet: withPet,
      destination: dest!,
      isWheelchairFriendly: wheelChairFriendly,
      pickupLocation: GeoPoint(mylocation.latitude, mylocation.longitude),
      price: (fare + luggageFee + convenienceFee),
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

  @override
  void initState() {
    // TODO: implement initState
    fetchDetails();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = context.csize!;
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Position? mylocation = ref.watch(coordinateProvider);
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
                      leading: Container(
                        decoration: BoxDecoration(
                            color: purplePalette.withOpacity(.7),
                            shape: BoxShape.circle),
                        child: BackButton(
                          color: Colors.white,
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            }
                          },
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
                              color: bgColor.darken(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        if (rider != null) ...{
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bookingType,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            "${rider!.vehicle.carBrand}, ${rider!.vehicle.carModel}",
                                            style: TextStyle(
                                              color: textColor.withOpacity(.5),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/images/cars/car${rider!.vehicle.type}.png",
                                      height: 55,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    // Column(
                                    //   children: [

                                    //     Tooltip(
                                    //       message: "Plate number",
                                    //       child: Container(
                                    //         padding: const EdgeInsets.symmetric(
                                    //             horizontal: 22, vertical: 5),
                                    //         decoration: BoxDecoration(
                                    //           color: (bgColor.darken()).withOpacity(.5),
                                    //           borderRadius: BorderRadius.circular(5),
                                    //         ),
                                    // child: Text(
                                    //   rider!.vehicle.plateNumber,
                                    //   style: TextStyle(
                                    //     color: textColor,
                                    //     fontSize: 17,
                                    //     fontWeight: FontWeight.w700,
                                    //   ),
                                    // ),
                                    //       ),
                                    //     )
                                    //   ],
                                    // )
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Plate Number",
                                      style: TextStyle(
                                        color: textColor.withOpacity(1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      rider!.vehicle.plateNumber,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Capacity",
                                      style: TextStyle(
                                        color: textColor.withOpacity(1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${rider!.vehicle.seats} Person${rider!.vehicle.seats > 1 ? "s" : ""}",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
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
                                        "${dest!.distanceBetween(mylocation!).toStringAsFixed(1)} KM",
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Fare",
                                        style: TextStyle(
                                          color: textColor.withOpacity(1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "AUD ${((double.parse(
                                              dest!
                                                  .distanceBetween(mylocation)
                                                  .toStringAsFixed(2),
                                            )) * rider!.vehicle.fare).toStringAsFixed(2)}",
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
                                const Gap(20),
                                InkWell(
                                  onTap: widget.bookingType == 1 ? null : () {},
                                  child: Text(
                                    "Pickup Location - ${widget.bookingType == 1 ? "Now" : pickupDateTime == null ? "Select Pickup Date & Time" : DateFormat("MMM dd yyyy Hm").format(pickupDateTime!)}",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Gap(5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: textColor.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.share_location_sharp,
                                        size: 20,
                                        color: textColor,
                                      ),
                                      const Gap(5),
                                      Expanded(
                                        child: FutureBuilder(
                                            future: Geocoder.google()
                                                .findAddressesFromGeoPoint(
                                              GeoPoint(mylocation!.latitude,
                                                  mylocation.longitude),
                                            ),
                                            builder: (_, f) {
                                              final List<GeoAddress>
                                                  currentAddress = f.data ?? [];
                                              if (currentAddress.isEmpty) {
                                                return Container();
                                              }
                                              return Text(
                                                // "${datum.coordinates.latitude}, ${datum.coordinates.longitude}",
                                                "${currentAddress.first.addressLine}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: context.theme
                                                      .secondaryHeaderColor,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                const Gap(20),
                                Text(
                                  "Destination",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const Gap(5),
                                InkWell(
                                  onTap: () async {
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => AbleMeMapPicker(
                                        geoPointCallback: (g) {
                                          setState(() {
                                            dest = g;
                                            map = PickupAndDestMap(
                                              key: Key(
                                                  "${g.latitude},${g.longitude}"),
                                              destination: dest,
                                              size: context.csize!.height * .56,
                                            );
                                          });
                                        },
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: textColor.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.share_location_sharp,
                                          size: 20,
                                          color: textColor,
                                        ),
                                        const Gap(5),
                                        Expanded(
                                          child: dest == null
                                              ? Text(
                                                  // "${datum.coordinates.latitude}, ${datum.coordinates.longitude}",
                                                  "Choose your destination",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: context.theme
                                                        .secondaryHeaderColor,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : FutureBuilder(
                                                  future: Geocoder.google()
                                                      .findAddressesFromGeoPoint(
                                                    dest!,
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
                                                      // "${datum.coordinates.latitude}, ${datum.coordinates.longitude}",
                                                      "${currentAddress.first.addressLine}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: context.theme
                                                            .secondaryHeaderColor,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    );
                                                  }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Passenger",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (passengerCount > 1) {
                                              passengerCount -= 1;
                                              if (mounted) setState(() {});
                                            }
                                          },
                                          height: 30,
                                          minWidth: 30,
                                          color: bgColor.lighten(),
                                          child: Center(
                                            child: Text(
                                              "-",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 10, vertical: 5),
                                        //   decoration: BoxDecoration(
                                        //       color: bgColor.lighten(),
                                        //       borderRadius: BorderRadius.circular(2)),
                                        //   child: InkWell(
                                        //     onTap: () {

                                        //     },
                                        //     child: Text(
                                        //       "-",

                                        //     ),
                                        //   ),
                                        // ),
                                        const Gap(20),
                                        Text(
                                          passengerCount.toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: textColor,
                                          ),
                                        ),
                                        const Gap(20),
                                        MaterialButton(
                                          onPressed: () {
                                            if (passengerCount <
                                                rider!.vehicle.seats) {
                                              passengerCount += 1;
                                              if (mounted) setState(() {});
                                            }
                                          },
                                          height: 30,
                                          minWidth: 30,
                                          color: bgColor.lighten(),
                                          child: Center(
                                            child: Text(
                                              "+",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 10, vertical: 5),
                                        //   decoration: BoxDecoration(
                                        //       color: bgColor.lighten(),
                                        //       borderRadius: BorderRadius.circular(2)),
                                        //   child: InkWell(
                                        //     onTap: () {

                                        //     },
                                        //     child: Text(
                                        //       "+",
                                        //       style: TextStyle(
                                        //         fontSize: 13,
                                        //         color: textColor,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Luggage",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (luggageCount > 0) {
                                              luggageCount -= 1;
                                              if (mounted) setState(() {});
                                            }
                                          },
                                          height: 30,
                                          minWidth: 30,
                                          color: bgColor.lighten(),
                                          child: Center(
                                            child: Text(
                                              "-",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Gap(20),
                                        Text(
                                          luggageCount.toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: textColor,
                                          ),
                                        ),
                                        const Gap(20),
                                        MaterialButton(
                                          onPressed: () {
                                            // if (luggageCount < rider!.vehicle.seats) {
                                            luggageCount += 1;
                                            if (mounted) setState(() {});
                                            // }
                                          },
                                          height: 30,
                                          minWidth: 30,
                                          color: bgColor.lighten(),
                                          child: Center(
                                            child: Text(
                                              "+",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                WheelChairFriendly(
                                  initState: wheelChairFriendly,
                                  onChange: (b) {
                                    setState(() {
                                      wheelChairFriendly = b;
                                    });
                                  },
                                ),
                                const Gap(20),
                                AdditionalInstructions(
                                  key: _kInstruction,
                                ),
                                if (dest != null) ...{
                                  const Gap(10),
                                  TotalCalculatorQuickRide(
                                    farePerLuggage: 0,
                                    luggages: luggageCount,
                                    passengers: passengerCount,
                                    farePerPassenger: rider!.vehicle.fare,
                                    distance: double.parse(
                                      dest!
                                          .distanceBetween(mylocation)
                                          .toStringAsFixed(2),
                                    ),
                                  ),
                                },
                                const Gap(30),
                                MaterialButton(
                                  height: 50,
                                  color: purplePalette,
                                  onPressed: () async {
                                    await book();
                                  },
                                  child: Center(
                                    child: Text(
                                      "Book ${rider!.fullname.capitalizeWords()}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        } else ...{
                          Center(
                            child: SizedBox(
                              height: size.height * .4,
                              child: FullScreenLoader(
                                showText: false,
                                size: size.width * .2,
                              ),
                            ),
                          )
                        },
                        // for (int i = 0; i < 20; i++) ...{
                        //   ListTile(
                        //     title: Text("$i"),
                        //   )
                        // },
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

  void fetchDetails() async {
    await api.getDetails(widget.id).then((value) {
      setState(() {
        rider = value;
      });
      if (value == null) {
        Fluttertoast.showToast(msg: "Unable to fetch rider details.");
        context.pop();
      }
      return;
    });
  }
}
