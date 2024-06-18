import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/helpers/widget/book_rider_widget_helpers/map_picker.dart';
import 'package:able_me/helpers/widget/custom_marker.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/booking_payload_vm.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DestinationPicker extends ConsumerStatefulWidget {
  const DestinationPicker({
    super.key,
    required this.onDestinationCallback,
    required this.onPickupcallback,
  });

  final ValueChanged<GeoPoint> onPickupcallback;
  final ValueChanged<GeoPoint> onDestinationCallback;

  @override
  ConsumerState<DestinationPicker> createState() => DestinationPickerState();
}

class DestinationPickerState extends ConsumerState<DestinationPicker>
    with ColorPalette {
  final BookingPayloadVM _vm = BookingPayloadVM.instance;
  late TextEditingController _pickup;
  late TextEditingController _dest;

  @override
  void initState() {
    super.initState();
    _pickup = TextEditingController();
    _dest = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initPoint();
    });
  }

  Future<void> initPoint() async {
    final coordinate = ref.read(coordinateProvider)!;
    await Geocoder.google()
        .findAddressesFromGeoPoint(coordinate.toGeoPoint())
        .then((value) {
      if (value.isNotEmpty) {
        _pickup.text = value.first.addressLine ?? "Unknown Location";
        _vm.updatePickupLocation(coordinate.toGeoPoint());
      }
    });
    _vm.stream.listen((event) {
      
    });
    // ref.watch(bookDataProvider.notifier).update((state) => state.copyWith(
    //     payload: state.payload.copyWith(
    //         pickupLocation:
    //             GeoPoint(coordinate.latitude, coordinate.longitude))));
    // ref
    //     .watch(bookDataProvider.notifier)
    //     .updatePickUp(GeoPoint(coordinate.latitude, coordinate.longitude));
  }

  @override
  void dispose() {
    _pickup.dispose();
    _dest.dispose();
    super.dispose();
  }

  bool isValidated() => _kForm.currentState?.validate() ?? false;

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
            hintText:
                isPickup ? "Where to pick you up?" : "Choose your destination",
            hintStyle: TextStyle(
              color: textColor.withOpacity(.3),
            ),
          ),
        ),
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
        Expanded(
          child: Form(
            key: _kForm,
            child: Column(
              children: [
                builder(
                  "Pick-up Location",
                  _pickup,
                  () async {
                    final GeoPoint? result =
                        await Navigator.of(context).push<GeoPoint>(
                      MaterialPageRoute(
                        builder: (_) => AbleMeMapPicker(
                          geoPointCallback: (g) async {
                            // ref.watch(bookDataProvider.notifier).update(
                            //     (state) => state.copyWith(
                            //         payload: state.payload
                            //             .copyWith(pickupLocation: g)));
                            _vm.updatePickupLocation(g);
                            await Geocoder.google()
                                .findAddressesFromGeoPoint(g)
                                .then((value) {
                              if (value.isNotEmpty) {
                                _pickup.text = value.first.addressLine ??
                                    "Unknown Address";
                                if (mounted) setState(() {});
                              }
                            });
                            widget.onPickupcallback(g);
                          },
                        ),
                      ),
                    );
                  },
                ),
                const Gap(20),
                builder(
                  "Destination",
                  _dest,
                  () async {
                    final GeoPoint? result =
                        await Navigator.of(context).push<GeoPoint>(
                      MaterialPageRoute(
                        builder: (_) => AbleMeMapPicker(
                          geoPointCallback: (g) async {
                            widget.onDestinationCallback(g);
                            _vm.updateDestination(g);
                            await Geocoder.google()
                                .findAddressesFromGeoPoint(g)
                                .then((value) {
                              if (value.isNotEmpty) {
                                _dest.text = value.first.addressLine ??
                                    "Unknown Address";
                                if (mounted) setState(() {});
                              }
                            });
                            // ref.watch(bookDataProvider.notifier).update(
                            //     (state) => state.copyWith(
                            //         payload: state.payload
                            //             .copyWith(destination: g)));
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
