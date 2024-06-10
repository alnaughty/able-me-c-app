import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/widget/book_rider_widget_helpers/map_picker.dart';
import 'package:able_me/helpers/widget/custom_marker.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DestinationPicker extends ConsumerStatefulWidget {
  const DestinationPicker(
      {super.key,
      required this.onDestinationCallback,
      required this.onPickupcallback});
  final ValueChanged<GeoPoint> onPickupcallback, onDestinationCallback;
  @override
  ConsumerState<DestinationPicker> createState() => DestinationPickerState();
}

class DestinationPickerState extends ConsumerState<DestinationPicker>
    with ColorPalette {
  final DateTime pickupDateTime = DateTime.now();
  GeoPoint? pickUpLocation;
  GeoPoint? dest;
  late final TextEditingController _pickup;
  late final TextEditingController _dest;
  @override
  void initState() {
    // TODO: implement initState
    initPlatform();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initPoint();
    });
    super.initState();
  }

  Future<void> initPoint() async {
    pickUpLocation = GeoPoint(
      ref.watch(coordinateProvider)!.latitude,
      ref.watch(coordinateProvider)!.longitude,
    );
    final List<GeoAddress> currentAddress =
        await Geocoder.google().findAddressesFromGeoPoint(pickUpLocation!);
    _pickup.text = currentAddress.first.addressLine ?? "Unknown Location";
    if (mounted) setState(() {});
  }

  initPlatform() async {
    _pickup = TextEditingController();
    _dest = TextEditingController();
  }

  dispPlatform() {
    _pickup.dispose();
    _dest.dispose();
  }

  @override
  void dispose() {
    dispPlatform();
    // TODO: implement dispose
    super.dispose();
  }

  bool isValidated() => _kForm.currentState!.validate();
  // GeoPoint getCoordinatesOf(int controllerIndex) {
  //   if (controllerIndex == 0) {
  //     return pickUpLocation!;
  //     // return _pickup.text;
  //   } else {
  //     assert(dest == null, "VALUE IS NULL!");
  //     return dest!;
  //   }
  // }

  Widget builder(
      String title, TextEditingController controller, Function() onPressed) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    final bool isPickup = title.contains("Pick-up");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(10),
        TextFormField(
          controller: controller,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
          ),
          validator: (text) {
            if (text == null) {
              return "Unexpected error";
            } else if (text.isEmpty) {
              return "Field cannot be empty";
            }
            return null;
          },
          readOnly: true,
          onTap: onPressed,
          decoration: InputDecoration(
            filled: true,
            fillColor: textColor.withOpacity(.1),
            prefixIcon: CustomMarkerAbleMe(
              size: 20,
              color: textColor,
            ),
            hintText: title.contains("Pick-up")
                ? "Where to get you?"
                : "Choose your destination",
            hintStyle: TextStyle(
              color: textColor.withOpacity(.3),
            ),
          ),
        )
      ],
    );
  }

  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        // CustomMarkerAbleMe(
        //   size: 30,
        //   color: purplePalette,
        // ),
        //     Container(
        //       margin: const EdgeInsets.symmetric(vertical: 5),
        //       height: 70,
        //       width: 1,
        //       color: textColor.withOpacity(.2),
        //     ),
        //     const CustomMarkerAbleMe(
        //       size: 30,
        //     ),
        //   ],
        // ).animate().slideX(duration: 1000.ms).fade(duration: 1000.ms),
        // const Gap(10),
        Expanded(
          child: Form(
            key: _kForm,
            child: Column(
              children: [
                builder(
                  "Pick-up Location",
                  _pickup,
                  () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AbleMeMapPicker(
                        geoPointCallback: (g) async {
                          final List<GeoAddress> currentAddress =
                              await Geocoder.google()
                                  .findAddressesFromGeoPoint(g);
                          _pickup.text = currentAddress.first.addressLine ??
                              "Unknown Location";
                          // _pickup.text = await Geocoder.google().findAddressesFromGeoPoint();
                          setState(() {
                            pickUpLocation = g;
                          });
                          _kForm.currentState!.validate();
                          widget.onPickupcallback(g);
                        },
                      ),
                    ));
                  },
                ),
                const Gap(20),
                builder(
                  "Destination",
                  _dest,
                  () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AbleMeMapPicker(
                        geoPointCallback: (g) async {
                          final List<GeoAddress> currentAddress =
                              await Geocoder.google()
                                  .findAddressesFromGeoPoint(g);
                          _dest.text = currentAddress.first.addressLine ??
                              "Unknown Location";
                          _kForm.currentState!.validate();
                          // _pickup.text = await Geocoder.google().findAddressesFromGeoPoint();
                          setState(() {
                            dest = g;
                          });
                          widget.onDestinationCallback(g);
                        },
                      ),
                    ));
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
