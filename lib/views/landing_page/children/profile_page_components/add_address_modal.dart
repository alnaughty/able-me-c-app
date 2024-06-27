import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class AddAddressModal extends StatefulWidget {
  const AddAddressModal({
    super.key,
    required this.coordinate,
    required this.onCallback,
  });
  final GeoPoint coordinate;
  final ValueChanged<AddressTuple<CurrentAddress, String>> onCallback;
  @override
  State<AddAddressModal> createState() => _AddAddressModalState();
}

class _AddAddressModalState extends State<AddAddressModal> with ColorPalette {
  final List<Map<String, dynamic>> _titles = [
    {"name": "Home", "icon": "loc_home", "id": 0},
    {"name": "Office", "icon": "loc_office", "id": 1},
    {"name": "Friend's House", "icon": "loc_friend", "id": 2},
    {"name": "Other Location", "icon": "loc_others", "id": 3}
  ];
  final TextEditingController _city = TextEditingController();
  final TextEditingController _locality = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _country = TextEditingController();
  // CurrentAddress? toAdd;a
  // required this.addressLine,
  //     required this.city,
  //     required this.coordinates,
  //     required this.locality,
  //     required this.countryCode
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  CurrentAddress? toAdd;
  Future<void> init() async {
    await Geocoder.google()
        .findAddressesFromGeoPoint(widget.coordinate)
        .then((v) {
      final List<GeoAddress> a = v;
      toAdd = CurrentAddress(
        addressLine: a.first.addressLine ?? "",
        city: a.first.adminAreaCode ?? "",
        coordinates: widget.coordinate,
        locality: a.first.locality ?? "",
        countryCode: a.first.countryCode ?? "",
      );
      _city.text = a.first.adminArea ?? "";
      _address.text = toAdd!.addressLine;
      _locality.text = toAdd!.locality;
      _country.text = a.first.countryName ?? "";
      if (mounted) setState(() {});
    });
  }

  int? selectedType;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
    super.initState();
  }

  bool disableTitle = false;
  String title = "";
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Container(
      width: context.csize!.width,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SingleChildScrollView(
        child: Form(
          key: _kForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Address Details"),
                titleTextStyle: TextStyle(
                    fontFamily: "Montserrat",
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                subtitle: const Text(
                    "Complete adddress would assist us better in serving you"),
                subtitleTextStyle: TextStyle(
                  fontFamily: "Montserrat",
                  color: textColor.withOpacity(.5),
                ),
                trailing: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: textColor.withOpacity(.7),
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select address type",
                    style: TextStyle(color: textColor.withOpacity(.8)),
                  ),
                  const Gap(10),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) {
                          final Map<String, dynamic> map = _titles[i];
                          final bool isSelected = selectedType == map['id'];
                          return MaterialButton(
                            elevation: 0,
                            color: isSelected
                                ? purplePalette.withOpacity(.3)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            onPressed: () {
                              if (isSelected) {
                                selectedType = null;
                                title = '';
                              } else {
                                selectedType = map['id'];
                                title = map['name'];
                              }
                              if (mounted) setState(() {});
                            },
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: isSelected
                                        ? purplePalette
                                        : textColor.withOpacity(.3)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/${map['icon']}.svg",
                                  height: 22,
                                  color: purplePalette,
                                ),
                                const Gap(10),
                                Text(map['name'])
                              ],
                            ),
                          );
                          // return RawChip(
                          //   onPressed: () {
                          //     setState(() {
                          //       selectedType = map['id'];
                          //     });
                          //   },
                          //   shape: RoundedRectangleBorder(
                          //       side: BorderSide(
                          //           color: selectedType == map['id']
                          //               ? purplePalette
                          //               : textColor.withOpacity(.2)),
                          //       borderRadius: BorderRadius.circular(10)),
                          //   selectedColor:
                          //       purplePalette.shade100.withOpacity(.3),
                          //   backgroundColor: bgColor,
                          //   selectedShadowColor: Colors.transparent,

                          //   checkmarkColor: null,
                          //   showCheckmark: false,
                          //   selected: selectedType == map['id'],
                          //   isEnabled: true,
                          //   // color: WidgetStateProperty.resolveWith((_) =>
                          //   //     selectedType == map['id'] ? null : bgColor),
                          //   elevation: 0,
                          //   label: Text(
                          //     map['name'],
                          //   ),
                          // );
                          // return InputChip(
                          //   onSelected: (d) {
                          //     setState(() {
                          //       selectedType = map['id'];
                          //     });
                          //   },
                          //   showCheckmark: false,
                          //   backgroundColor: Colors.red,
                          //   // color: Colors.transparent,
                          //   selectedColor: purplePalette.withOpacity(.2),
                          //   // backgroundColor: selectedType == map['id']
                          //   //     ? purplePalette.withOpacity(.2)
                          //   //     : Colors.transparent,
                          //   shadowColor: Colors.transparent,
                          //   avatarBorder: RoundedRectangleBorder(
                          //     side: BorderSide(color: bgColor, width: 1),
                          //   ),
                          //   elevation: 0,
                          //   selected: selectedType == map['id'],
                          //   color:
                          //       WidgetStateProperty.resolveWith((_) => bgColor),
                          //   label: Text(
                          //     map['name'],
                          //   ),
                          //   avatar: SvgPicture.asset(
                          //     "assets/icons/${map['icon']}.svg",
                          //     color: purplePalette,
                          //   ),
                          // );
                        },
                        separatorBuilder: (_, i) => const SizedBox(
                              width: 15,
                            ),
                        itemCount: _titles.length),
                  )
                ],
              ),
              const Gap(30),
              // TextFormField(
              //   enabled: !disableTitle,
              //   controller: _title,
              //   style: TextStyle(
              //     color: textColor,
              //   ),
              //   validator: (text) {
              //     if (text == null) {
              //       return "Unexpected Error";
              //     } else if (text.isEmpty) {
              //       return "This field is required";
              //     }
              //     return null;
              //   },
              //   decoration: const InputDecoration(
              //       hintText: "e.g. Home, Office",
              //       isDense: false,
              //       labelText: "Title"),
              // ),
              if (toAdd != null) ...{
                const Gap(10),
                TextFormField(
                  readOnly: true,
                  controller: _address,
                  style: TextStyle(
                    color: textColor,
                  ),
                  maxLines: 2,
                  minLines: 1,
                  decoration: const InputDecoration(
                      hintText: "Address Line",
                      isDense: false,
                      labelText: "Address Line"),
                ),
                // ignore: equal_elements_in_set
                const Gap(10),
                TextFormField(
                  readOnly: true,
                  controller: _city,
                  style: TextStyle(
                    color: textColor,
                  ),
                  decoration: const InputDecoration(
                      hintText: "City", isDense: false, labelText: "City"),
                ),
                // ignore: equal_elements_in_set
                const Gap(10),
                TextFormField(
                  readOnly: true,
                  controller: _locality,
                  style: TextStyle(
                    color: textColor,
                  ),
                  decoration: const InputDecoration(
                      hintText: "Locality",
                      isDense: false,
                      labelText: "Locality"),
                ),
                // ignore: equal_elements_in_set
                const Gap(10),
                TextFormField(
                  readOnly: true,
                  controller: _country,
                  style: TextStyle(
                    color: textColor,
                  ),
                  decoration: const InputDecoration(
                      hintText: "Country",
                      isDense: false,
                      labelText: "Country"),
                ),
                const Gap(30),
                MaterialButton(
                  height: 55,
                  color: purplePalette,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () async {
                    if (selectedType != null && title.isNotEmpty) {
                      setState(() {});
                      // ADD
                      widget.onCallback(
                          AddressTuple(address: toAdd!, val: title));
                      Navigator.of(context).pop();
                    } else {
                      Fluttertoast.showToast(msg: "Select Type");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SafeArea(
                    top: false,
                    child: SizedBox(
                      height: 20,
                    ))
              },
            ],
          ),
        ),
      ),
    );
  }
}

class AddressTuple<y, x> {
  final y address;
  final x val;
  const AddressTuple({required this.address, required this.val});
}
