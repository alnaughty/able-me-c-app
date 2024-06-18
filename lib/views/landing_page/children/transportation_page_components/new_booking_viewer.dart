import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/date_ext.dart';
import 'package:able_me/models/rider_booking/booking_data.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/booking_payload_vm.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/departure_and_misc.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/destination_picker.dart';
import 'package:able_me/views/landing_page/children/home_page_components/ride_chosen/pickup_and_destination_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class NewBookingViewer extends ConsumerStatefulWidget {
  const NewBookingViewer(
      {super.key,
      required this.onPayloadCreated,
      required this.destK,
      required this.onBookPressed,
      required this.deptMiscK});
  final ValueChanged<BookingPayload> onPayloadCreated;
  final GlobalKey<DestinationPickerState> destK;
  final GlobalKey<DepartureAndMiscState> deptMiscK;
  final Function() onBookPressed;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewBookingViewerState();
}

class _NewBookingViewerState extends ConsumerState<NewBookingViewer>
    with ColorPalette {
  final BookingPayloadVM _vm = BookingPayloadVM.instance;
  // late final GlobalKey<DestinationPickerState> _kDest = widget.destK;
  // late final GlobalKey<DepartureAndMiscState> _kDeptMisc = widget.deptMiscK;
  late GeoPoint pickUpLocation = GeoPoint(
    ref.watch(coordinateProvider)!.latitude,
    ref.watch(coordinateProvider)!.longitude,
  );
  DateTime initDate = DateTime.now();
  // DateTime type = 0;
  Widget customRadio(
    String title,
    DateTime value,
    int transpotype,
  ) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    print(value);
    return InkWell(
      onTap: () {
        widget.deptMiscK.currentState!.updateDate(value);
        _vm.updateTranspoType(transpotype);
        setState(() {
          initDate = value;
        });
        print(value.month);
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: initDate.isSameDay(value)
                    ? purplePalette
                    : textColor.withOpacity(.1),
                border: Border.all(color: Colors.white.withOpacity(.5)),
                borderRadius: BorderRadius.circular(5)),
            // child: MaterialButton(
            // color: initDate.isSameDay(value)
            //     ? purplePalette
            //     : textColor.withOpacity(.1),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5)),
            //   onPressed: () {
            //     widget.deptMiscK.currentState!.updateDate(value);
            //     setState(() {
            //       initDate = value;
            //     });
            //     print(value.month);
            //   },
            // ),
          ),
          const Gap(5),
          Text(
            title,
            style: TextStyle(
              color: textColor,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            customRadio("Short Notice", DateTime.now(), 2),
            const Gap(20),
            customRadio("Pre-scheduled", DateTime.now().add(1.days), 3),
          ],
        ),
        const Gap(20),
        DestinationPicker(
          key: widget.destK,
          onDestinationCallback: (g) {
            widget.onPayloadCreated(_vm.value.copyWith(destination: g));
          },
          onPickupcallback: (g) {
            widget.onPayloadCreated(_vm.value.copyWith(pickupLocation: g));
          },
        ),
        const Gap(20),
        DepartureAndMisc(
          key: widget.deptMiscK,
          initDate: initDate,
          onNoteCallback: (n) {
            setState(() {
              // note = n;
            });
          },
          dateEditable: !initDate.isSameDay(DateTime.now()),
          onDateCallback: (d) {
            // setState(() {
            //   pickupDateTime = d;
            // });
          },
          onTimeCallback: (t) {
            setState(() {
              // pickupTime = t;
            });
          },
          withPetCallback: (b) {
            setState(() {
              // withPet = b;
            });
          },
          wheelChairFriendlyCallback: (b) {
            setState(() {
              // wheelChairFriendly = b;
            });
          },
          budgetCallback: (i) {
            setState(() {
              // price = i;
            });
          },
          passengerCallback: (i) {
            setState(() {
              // passengerCount = i;
            });
          },
          luggageCallback: (i) {
            setState(() {
              // luggageCount = i;
            });
          },
        ),
      ],
    );
  }

  Widget field(TextEditingController controller) => Container();
}
