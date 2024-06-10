import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/widget/book_rider_widget_helpers/map_picker.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/category.dart';
import 'package:able_me/models/rider_booking/rider_booking_payloads.dart';
import 'package:able_me/models/rider_booking/task.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class RiderTextControllers extends ConsumerStatefulWidget {
  const RiderTextControllers({super.key, required this.onFinishCallback});
  final ValueChanged<RiderBookingPayloads> onFinishCallback;
  @override
  ConsumerState<RiderTextControllers> createState() =>
      _RiderTextControllersState();
}

class _RiderTextControllersState extends ConsumerState<RiderTextControllers>
    with ColorPalette {
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  late final TextEditingController _pricing;
  late final TextEditingController _title;
  late final TextEditingController _description;
  int? type;
  GeoPoint? destination;
  GeoPoint? pickUpPoint;
  final List<Category> categories = const [
    Category(name: "Transpo", assetImage: "assets/icons/car.svg", type: 1),
    Category(
        name: "Food Delivery", assetImage: "assets/icons/food.svg", type: 2),
    Category(
        name: "Medicine", assetImage: "assets/icons/medicine.svg", type: 3),
  ];
  final List<AdditionalTask> tasks = [];
  @override
  void initState() {
    _pricing = TextEditingController();
    _title = TextEditingController();
    _description = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pricing.dispose();
    _title.dispose();
    _description.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Category",
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...categories.map(
                  (e) => GestureDetector(
                    onTap: () {
                      if (e.type == 1) {}
                      setState(() {
                        if (type == e.type) {
                          type = null;
                          pickUpPoint = null;
                          destination = null;
                        } else {
                          type = e.type;
                          final Position? pos = ref.watch(coordinateProvider);
                          if (pos == null) return;
                          if (type == 1) {
                            pickUpPoint = GeoPoint(
                              pos.latitude,
                              pos.longitude,
                            );
                            destination = null;
                          } else if (type! > 1) {
                            destination = GeoPoint(
                              pos.latitude,
                              pos.longitude,
                            );
                            pickUpPoint = null;
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      constraints: const BoxConstraints(
                        minWidth: 110,
                      ),
                      decoration: BoxDecoration(
                          color: type != e.type
                              ? Colors.transparent
                              : purplePalette,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: type != e.type
                                  ? textColor.withOpacity(.2)
                                  : Colors.transparent)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              e.assetImage,
                              color: e.type == type
                                  ? Colors.white
                                  : textColor.withOpacity(.5),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            e.name,
                            style: TextStyle(
                              color: e.type == type
                                  ? Colors.white
                                  : textColor.withOpacity(.5),
                              fontSize: 12,
                              fontWeight: e.type == type
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ), // Category,
            if (type != null && type! > 1) ...{
              const Gap(5),
              Text(
                "NOTE: You will be required to reimburse all the payments that the driver paid when purchasing your item from the store.",
                style: TextStyle(
                  color: purplePalette,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              )
            },
            const Gap(20),
            Form(
              key: _kForm,
              child: Column(
                children: [
                  TextFormField(
                    validator: (text) {
                      if (text == null) {
                        return "Invalid field";
                      } else if (text.isEmpty) {
                        return "This field cannot be empty";
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: textColor,
                    ),
                    cursorColor: purplePalette,
                    controller: _title,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "e.g Buy Food at McDonalds",
                      hintStyle: TextStyle(
                        color: textColor.withOpacity(.5),
                      ),
                      labelText: "Title",
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Column(
                    children: [
                      TextFormField(
                        validator: (text) {
                          if (text == null) {
                            return "Invalid field";
                          } else if (text.isEmpty) {
                            return "This field cannot be empty";
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: textColor,
                        ),
                        onFieldSubmitted: (t) {
                          _kForm.currentState!.validate();
                        },
                        cursorColor: purplePalette,
                        controller: _pricing,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Price",
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(.5),
                          ),
                          labelText: "Price",
                          labelStyle: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ),
                      if (type != null && type! > 1) ...{
                        const Gap(5),
                        Text(
                          "Price is only the transaction price between you and the driver",
                          style: TextStyle(
                              color: purplePalette,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      },
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Destination",
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.w600),
                ),
                if (type != null && type! > 1) ...{
                  Text(
                    "When choosing `Food Delivery` or `Medicine` it will automatically use your current location as the destination location",
                    style: TextStyle(
                      color: textColor.withOpacity(.5),
                      fontSize: 11,
                    ),
                  ),
                } else if (type == 1) ...{
                  Text(
                    "Pin the location you want to go",
                    style: TextStyle(
                      color: textColor.withOpacity(.5),
                      fontSize: 11,
                    ),
                  ),
                },
                const Gap(10),
                MaterialButton(
                  onPressed: type == null || (type != null && type! > 1)
                      ? null
                      : () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AbleMeMapPicker(
                              geoPointCallback: (g) {
                                setState(() {
                                  destination = g;
                                });
                              },
                            ),
                          ));
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                      side: BorderSide(
                        color: textColor,
                      )),
                  height: 60,
                  child: Center(
                    child: destination == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_searching_outlined,
                                color: context.theme.secondaryHeaderColor
                                    .withOpacity(.5),
                                size: 18,
                              ),
                              const Gap(10),
                              Text(
                                // "${datum.coordinates.latitude}, ${datum.coordinates.longitude}",
                                "Choose location",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.secondaryHeaderColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          )
                        : FutureBuilder(
                            future: Geocoder.google().findAddressesFromGeoPoint(
                              destination!,
                            ),
                            builder: (_, f) {
                              final List<GeoAddress> currentAddress =
                                  f.data ?? [];
                              if (currentAddress.isEmpty) {
                                return Container();
                              }
                              return Text(
                                // "${datum.coordinates.latitude}, ${datum.coordinates.longitude}",
                                "${currentAddress.first.addressLine}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.secondaryHeaderColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              );
                            }),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pickup location",
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.w600),
                ),
                if (type == 1) ...{
                  Text(
                    "When choosing `Transpo`it will automatically use your current location as your pickup location",
                    style: TextStyle(
                      color: textColor.withOpacity(.5),
                      fontSize: 11,
                    ),
                  ),
                } else if (type != null && type! > 1) ...{
                  Text(
                    "Pin the location of the ${type == 2 ? "Restaurant" : "Pharmacy"} as the pickup location",
                    style: TextStyle(
                      color: textColor.withOpacity(.5),
                      fontSize: 11,
                    ),
                  ),
                },
                const Gap(10),
                MaterialButton(
                  onPressed: type == null || type == 1
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AbleMeMapPicker(
                              geoPointCallback: (g) {
                                setState(() {
                                  pickUpPoint = g;
                                });
                              },
                            ),
                          ));
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                      side: BorderSide(
                        color: textColor,
                      )),
                  height: 60,
                  child: Center(
                    child: pickUpPoint == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_searching_outlined,
                                color: context.theme.secondaryHeaderColor
                                    .withOpacity(.5),
                                size: 18,
                              ),
                              const Gap(5),
                              Text(
                                // "${datum.coordinates.latitude}, ${datum.coordinates.longitude}",
                                "Choose location",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.secondaryHeaderColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          )
                        : FutureBuilder(
                            future: Geocoder.google().findAddressesFromGeoPoint(
                              pickUpPoint!,
                            ),
                            builder: (_, f) {
                              final List<GeoAddress> currentAddress =
                                  f.data ?? [];
                              if (currentAddress.isEmpty) {
                                return Container();
                              }
                              return Text(
                                // "${datum.coordinates.latitude}, ${datum.coordinates.longitude}",
                                "${currentAddress.first.addressLine}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.secondaryHeaderColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              );
                            }),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (type != null && type! > 1) ...{
          const Gap(20),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Additional Tasks",
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.w600),
                ),
                const Gap(10),
                ...tasks.map(
                  (e) => ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          tasks.remove(e);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    title: Text(
                      e.title,
                    ),
                    titleTextStyle: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                    subtitle: Text(
                      e.desc,
                    ),
                    subtitleTextStyle: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          )
        },
        const Gap(25),
        MaterialButton(
          color: purplePalette,
          disabledColor: Colors.grey,
          onPressed: pickUpPoint == null ||
                  destination == null ||
                  !_kForm.currentState!.validate() ||
                  type == null
              ? null
              : () {
                  if (type == 1) {
                    tasks.clear();
                  }
                  widget.onFinishCallback(
                    RiderBookingPayloads(
                      title: _title.text,
                      description: "",
                      price: double.parse(_pricing.text),
                      destination: destination!,
                      pickupLocation: pickUpPoint!,
                      tasks: tasks,
                      type: type!,
                    ),
                  );
                },
          height: 60,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
          child: const Center(
            child: Text(
              "Submit",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
