import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/globals.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

// ignore: must_be_immutable
class RegistrationDetails extends StatefulWidget {
  const RegistrationDetails({super.key, required this.valueCallback});
  final ValueChanged<List<String>> valueCallback;

  @override
  State<RegistrationDetails> createState() => _RegistrationDetailsState();
}

class _RegistrationDetailsState extends State<RegistrationDetails>
    with ColorPalette {
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  late final TextEditingController _fname;
  late final TextEditingController _lname;
  late final TextEditingController _address;
  final FocusNode _fNode = FocusNode();
  final FocusNode _lnode = FocusNode();
  final FocusNode _addressNode = FocusNode();

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final Position pos = await Geolocator.getCurrentPosition();
      // Geocoder.google().findAddressesFromCoordinates(coordinates)
      // GBData data = await GeocoderBuddy.findDetails(pos);
      // setState(() {
      //   isLoading = false;
      //   details = data.toJson();
      // });
      // print(data.address.village);
      // _address.text =
      if (mounted) setState(() {});
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void finish() {
    // List<String> values = List.generate(4, (index) => "", growable: false);
    final List<String> values = [_fname.text, _lname.text, _address.text];
    widget.valueCallback(values);
    return;
  }

  @override
  void initState() {
    // TODO: implement initState
    _fname = TextEditingController();
    _lname = TextEditingController();
    _address = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _determinePosition();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF3F3F3),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      width: size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //this is TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo(size.width * .1),
                const Gap(10),
                Text(
                  "ABLE ME",
                  style: fontTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            const Gap(30),
            Text(
              "Details",
              style: fontTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Enter your personal informations to create an account.",
              style: fontTheme.bodyMedium!.copyWith(
                color: Colors.black.withOpacity(.5),
                // fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(25),
            Text(
              "Note: We value your data, we don’t share any of the data to anyone",
              style: fontTheme.bodyMedium!.copyWith(
                color: blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(15),
            Form(
              key: _kForm,
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _fNode,
                    controller: _fname,
                    // autovalidateMode: AutovalidateMode.always,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),

                    onEditingComplete: () async {
                      print("Complete");
                      final bool isValidated = _kForm.currentState!.validate();
                      if (isValidated) {
                        print("VALID");
                        // await register();
                        // await login();
                        finish();
                      } else {
                        if (_lname.text.isEmpty) {
                          _lnode.requestFocus();
                          return;
                        } else if (_address.text.isEmpty) {
                          _addressNode.requestFocus();
                          return;
                        }
                      }
                      // final bool isValidated = _kForm.currentState!.validate();
                      // if (isValidated) {
                      //   // await login();
                      //   print("GOODS");
                      //   // await register();
                      // }
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Firstname",
                      label: const Text("Firstname"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _fname.clear();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 15,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 650.ms).slideY(begin: 1, end: 0),
                  const Gap(10),
                  TextFormField(
                    controller: _lname,
                    focusNode: _lnode,
                    // autovalidateMode: AutovalidateMode.always,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    onChanged: (text) {
                      setState(() {
                        // _pwdText = text;
                      });
                    },
                    onEditingComplete: () async {
                      final bool isValidated = _kForm.currentState!.validate();
                      if (isValidated) {
                        print("VALID");
                        // await register();
                        // await login();
                        finish();
                      } else {
                        if (_fname.text.isEmpty) {
                          _fNode.requestFocus();
                          return;
                        } else if (_address.text.isEmpty) {
                          _addressNode.requestFocus();
                          return;
                        }
                      }
                    },
                    keyboardType: TextInputType.name,

                    decoration: InputDecoration(
                      hintText: "Lastname",
                      // hintText: "⁕⁕⁕⁕⁕",
                      label: Text("Lastname"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _fname.clear();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 15,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 700.ms).slideY(begin: 1, end: 0),
                  const Gap(10),
                  TextFormField(
                    controller: _address,
                    focusNode: _addressNode,
                    onChanged: (text) {
                      // setState(() {
                      //   _confPwdText = text;
                      // });
                    },
                    // autovalidateMode: AutovalidateMode.always,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    onEditingComplete: () async {
                      final bool isValidated = _kForm.currentState!.validate();
                      if (isValidated) {
                        print("VALID");
                        // await login();
                        // await register();

                        finish();
                      } else {
                        if (_fname.text.isEmpty) {
                          _fNode.requestFocus();
                          return;
                        } else if (_lname.text.isEmpty) {
                          _lnode.requestFocus();
                          return;
                        }
                      }
                    },
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      hintText: "Address",
                      // hintText: "⁕⁕⁕⁕⁕",
                      label: Text("Address"),
                    ),
                  ).animate().fadeIn(duration: 750.ms).slideY(begin: 1, end: 0),
                ],
              ),
            ),
            const Gap(20),
            Text.rich(
              TextSpan(
                text: "By creating an account, you agree to the ",
                style: fontTheme.bodyMedium!.copyWith(
                  color: Colors.black.withOpacity(.5),
                  fontFamily: "Montserrat",
                ),
                children: [
                  TextSpan(
                    text: "Terms of use",
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    style: TextStyle(
                        color: greenPalette,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: greenPalette),
                  ),
                  const TextSpan(
                    text:
                        ". For more information about Able Me's privacy practices, see the ",
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    style: TextStyle(
                        color: greenPalette,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: greenPalette),
                  ),
                  const TextSpan(
                    text:
                        ". We'll occasionally send you account-related emails.",
                  ),
                ],
              ),
            ),
            const Gap(35),
            MaterialButton(
              height: 60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60)),
              color: greenPalette,
              onPressed: () async {
                // final bool isEmailValid = _kEmailForm.currentState!.validate();
                final bool isValidated = _kForm.currentState!.validate();
                if (isValidated) {
                  print("VALID");
                  // await register();
                  finish();
                }
              },
              child: Center(
                child: Text(
                  "SUBMIT",
                  style: fontTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 700.ms).slideY(begin: 1, end: 0),
            const SafeArea(
              child: Gap(15),
            ),
          ],
        ),
      ),
    );
  }
}
