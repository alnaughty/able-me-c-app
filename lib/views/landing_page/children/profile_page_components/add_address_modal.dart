import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

class _AddAddressModalState extends State<AddAddressModal> {
  final TextEditingController _title = TextEditingController();
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
  CurrentAddress? toAdd;
  Future<void> init() async {
    await Geocoder.google()
        .findAddressesFromGeoPoint(widget.coordinate)
        .then((v) {
      final List<GeoAddress> a = v;
      toAdd = CurrentAddress(
        addressLine: a.first.addressLine ?? "",
        city: a.first.adminArea ?? "",
        coordinates: widget.coordinate,
        locality: a.first.locality ?? "",
        countryCode: a.first.countryName ?? "",
      );
      _city.text = toAdd!.city;
      _address.text = toAdd!.addressLine;
      _locality.text = toAdd!.locality;
      _country.text = toAdd!.countryCode;
      if (mounted) setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
    super.initState();
  }

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
            TextFormField(
              controller: _title,
              style: TextStyle(
                color: textColor,
              ),
              decoration: const InputDecoration(
                  hintText: "e.g. Home, Office",
                  isDense: false,
                  labelText: "Title"),
            ),
            if (toAdd != null) ...{
              TextFormField(
                readOnly: true,
                controller: _city,
                style: TextStyle(
                  color: textColor,
                ),
                decoration: const InputDecoration(
                    hintText: "City", isDense: false, labelText: "City"),
              ),
            },
          ],
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
