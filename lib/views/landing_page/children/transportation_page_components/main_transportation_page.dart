import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/category.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/views/landing_page/children/home_page_components/driver_and_user_map.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/departure_and_misc.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/destination_picker.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/pickup_and_destination_map.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/new_booking_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class MainTransportationPage extends ConsumerStatefulWidget {
  const MainTransportationPage({super.key, required this.onBookPressed});
  final Function() onBookPressed;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      MainTransportationPageState();
}

class MainTransportationPageState extends ConsumerState<MainTransportationPage>
    with ColorPalette {
  final GlobalKey<DestinationPickerState> _kDest =
      GlobalKey<DestinationPickerState>();
  final GlobalKey<DepartureAndMiscState> _kDeptMisc =
      GlobalKey<DepartureAndMiscState>();
  final List<Category> rideTypes = [
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});

    super.initState();
  }

  late GeoPoint pickUpLocation = GeoPoint(
    ref.watch(currentAddressNotifier)!.coordinates.latitude,
    ref.watch(currentAddressNotifier)!.coordinates.longitude,
  );
  late PickupAndDestMap map = PickupAndDestMap(
    key: Key("$pickUpLocation"),
    destination: null,
    pickUpLocation: pickUpLocation,
    size: context.csize!.height * .65,
  );
  // PickupAndDestMap? map;
  @override
  Widget build(BuildContext context) {
    final CurrentAddress? ad = ref.watch(currentAddressNotifier);
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final Size size = MediaQuery.of(context).size;
    final CurrentAddress? address = ref.watch(currentAddressNotifier);
    return ad == null
        ? Container()
        : CustomScrollView(
            shrinkWrap: true,
            slivers: [
              // map ??
              //       Container(
              //         width: size.width,
              //         color: Colors.red,
              //         height: size.height * .65,
              //       )

              SliverAppBar(
                pinned: true,
                floating: true,
                stretch: true,
                forceMaterialTransparency: true,
                backgroundColor: Colors.red,
                // bottom: PreferredSize(
                //     preferredSize: const Size.fromHeight(0), child: Container()),
                // flexibleSpace: FlexibleSpaceBar(
                //   collapseMode: CollapseMode.pin,
                //   background:
                // ),
                flexibleSpace: SizedBox(
                    width: size.width,
                    height: size.height * .65,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: map,
                        ),
                        if (address != null) ...{
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 10,
                            child: SafeArea(
                              bottom: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/location.svg",
                                    color: purplePalette,
                                    width: 20,
                                  ),
                                  const Gap(5),
                                  Text(
                                    "${address.locality}, ${address.city}, ${address.countryCode}"
                                        .capitalizeWords(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: purplePalette,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        },
                        // Positioned(
                        //     right: 10,
                        //     top: 0,
                        //     child: SafeArea(
                        //       bottom: false,
                        //       child: IconButton(
                        //         onPressed: () {},
                        //         tooltip: "History",
                        //         style: ButtonStyle(
                        //             backgroundColor: WidgetStateProperty.resolveWith(
                        //               (_) => purplePalette,
                        //             ),
                        //             foregroundColor: WidgetStateProperty.resolveWith(
                        //                 (_) => Colors.white)),
                        //         icon: const Icon(Icons.history),
                        //       ),
                        //     )),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: size.width,
                            height: 40,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(50),
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 80,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: bgColor.darken(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                expandedHeight: size.height * .45,
                collapsedHeight: size.height * .35,
              ),
              SliverList.list(children: [
                Center(
                  child: Text(
                    "Lets book your next trip",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Column(
                    children: [
                      NewBookingViewer(
                          onBookPressed: widget.onBookPressed,
                          onPayloadCreated: (payload) {
                            if (payload.payload.destination != null &&
                                payload.updateMap) {
                              map = PickupAndDestMap(
                                key: Key(
                                    "${DateTime.now().microsecondsSinceEpoch}"),
                                pickUpLocation: payload.payload.pickupLocation,
                                destination: payload.payload.destination,
                                size: size.height * .65,
                              );
                              if (mounted) setState(() {});
                            }
                          },
                          destK: _kDest,
                          deptMiscK: _kDeptMisc),
                      const Gap(20),
                      MaterialButton(
                        height: 55,
                        color: purplePalette,
                        onPressed: () async {
                          final bool isDestGood =
                              _kDest.currentState!.isValidated();
                          final bool isDeptGood =
                              _kDeptMisc.currentState!.isValidated();
                          if (isDestGood && isDeptGood) {
                            widget.onBookPressed();
                            map = PickupAndDestMap(
                              key: Key("$pickUpLocation"),
                              destination: null,
                              pickUpLocation: pickUpLocation,
                              size: context.csize!.height * .65,
                            );
                            if (mounted) setState(() {});
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Book",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // child: Column(
                  //   children: [
                  //     // DestinationPicker(
                  //     //   key: _kDest,
                  //     //   onDestinationCallback: (g) {},
                  //     //   onPickupcallback: (g) {},
                  //     // ),
                  //   ],
                  // ),
                ),

                // Container(
                //   width: size.width,
                //   height: 40,
                //   color: Colors.red,
                // ),
                const SafeArea(
                  child: SizedBox(
                    height: 20,
                  ),
                )
              ])
            ],
          );
    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       Container(
    // width: size.width,
    // color: Colors.red,
    // height: size.height * .65,
    //       ),
    //       // DriverAndUserMap(riderPoint: null)
    //       // Container(
    //       //   width: double.infinity,
    //       //   decoration: BoxDecoration(
    //       //       gradient: LinearGradient(
    //       //     colors: [
    //       //       purplePalette,
    //       //       bgColor,
    //       //     ],
    //       //     begin: Alignment.topCenter,
    //       //     end: Alignment.bottomCenter,
    //       //   )),
    //       //   child: Column(
    //       //     crossAxisAlignment: CrossAxisAlignment.start,
    //       //     children: [
    //       //       PreferredSize(
    //       //         preferredSize: const Size.fromHeight(65),
    //       //         child: AppBar(
    //       //             backgroundColor: Colors.transparent,
    //       //             centerTitle: true,
    //       //             leadingWidth: 90,
    //       //             leading: _udata != null
    //       //                 ? Center(
    //       //                     child: CustomImageBuilder(
    //       //                       avatar: _udata.avatar,
    //       //                       placeHolderName: _udata.name[0].toUpperCase(),
    //       //                     ),
    //       //                   )
    //       //                 : null,
    //       //             actions: [
    //       //               IconButton(
    //       //                   tooltip: "History & Transactions",
    //       //                   onPressed: () {},
    //       //                   icon: const Icon(
    //       //                     Icons.receipt_long,
    //       //                     color: Colors.white,
    //       //                   )),
    //       //               if (_udata != null) ...{
    //       //                 Container(
    //       //                   width: 5,
    //       //                 )
    //       //               },
    //       //             ],
    //       //             title: pos == null
    //       //                 ? Text(
    //       //                     "Unknown Location",
    //       //                     style: TextStyle(
    //       //                         fontFamily: "Montserrat",
    //       //                         color: textColor,
    //       //                         fontSize: 13,
    //       //                         fontWeight: FontWeight.w700),
    //       //                   )
    //       //                 : FutureBuilder(
    //       //                     future: Geocoder.google()
    //       //                         .findAddressesFromCoordinates(
    //       //                       Coordinates(pos.latitude, pos.longitude),
    //       //                     ),
    //       //                     builder: (_, f) {
    //       //                       final List<GeoAddress> currentAddress =
    //       //                           f.data ?? [];

    //       //                       return Row(
    //       //                         mainAxisAlignment: MainAxisAlignment.center,
    //       //                         children: [
    //       //                           SvgPicture.asset(
    //       //                             "assets/icons/location.svg",
    //       //                             color: Colors.white,
    //       //                             width: 20,
    //       //                           ),
    //       //                           const Gap(5),
    //       //                           if (currentAddress.isEmpty) ...{
    //       //                             const Text(
    //       //                               "Unknown Location",
    //       //                               style: TextStyle(
    //       //                                   fontFamily: "Montserrat",
    //       //                                   color: Colors.white,
    //       //                                   fontSize: 13,
    //       //                                   fontWeight: FontWeight.w700),
    //       //                             )
    //       //                           } else ...{
    //       //                             Text(
    //       //                               "${currentAddress.first.locality}, ${currentAddress.first.countryCode}",
    //       //                               overflow: TextOverflow.ellipsis,
    //       //                               style: const TextStyle(
    //       //                                 fontFamily: "Montserrat",
    //       //                                 color: Colors.white,
    //       //                                 fontSize: 13,
    //       //                                 fontWeight: FontWeight.w700,
    //       //                               ),
    //       //                             ),
    //       //                           },
    //       //                         ],
    //       //                       );
    //       //                     })),
    //       //       ),
    //       //       Padding(
    //       //         padding:
    //       //             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //       //         child: Column(
    //       //           crossAxisAlignment: CrossAxisAlignment.start,
    //       //           children: [
    //       //             Text(
    //       //               "Hello ${_udata?.name.capitalizeWords() ?? ""}!",
    //       //               style: TextStyle(
    //       //                 fontFamily: "Montserrat",
    //       //                 fontSize: 14,
    //       //                 color: Colors.white.withOpacity(1),
    //       //                 fontWeight: FontWeight.w600,
    //       //               ),
    //       //             ),
    //       //             const Text(
    //       //               "Let's book your next trip!",
    //       //               style: TextStyle(
    //       //                 fontSize: 22,
    //       //                 color: Colors.white,
    //       //                 fontWeight: FontWeight.w700,
    //       //               ),
    //       //             ),
    //       //             const Gap(30),
    //       //             Container(
    //       //               padding: const EdgeInsets.all(20),
    //       //               decoration: BoxDecoration(
    //       //                 color: bgColor.lighten(),
    //       //                 borderRadius: BorderRadius.circular(10),
    //       //               ),
    //       //               child: NewBookingViewer(
    //       //                 destK: _kDest,
    //       //                 deptMiscK: _kDeptMisc,
    //       //                 onPayloadCreated: (payload) {},
    //       //               ),
    //       //             )
    //       //           ],
    //       //         ),
    //       //       )
    //       //     ],
    //       //   ),
    //       // ),
    //       // const Gap(0),
    //       // Padding(
    //       //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    //       //   child: MaterialButton(
    //       //     height: 60,
    //       //     color: purplePalette,
    //       //     onPressed: () async {
    //       //       final bool isDestGood = _kDest.currentState!.isValidated();
    //       //       final bool isDeptGood = _kDeptMisc.currentState!.isValidated();
    //       //       if (isDestGood && isDeptGood) {
    //       //         print("GOOD");
    //       //       }
    //       //     },
    //       //     shape: RoundedRectangleBorder(
    //       //         borderRadius: BorderRadius.circular(10)),
    //       //     child: const Center(
    //       //       child: Text(
    //       //         "Submit",
    //       //         style: TextStyle(
    //       //           color: Colors.white,
    //       //           fontWeight: FontWeight.w600,
    //       //         ),
    //       //       ),
    //       //     ),
    //       //   ),
    //       // ),
    // const SafeArea(
    //   child: SizedBox(
    //     height: 20,
    //   ),
    // )
    //     ],
    //   ),
    // );
  }
}
