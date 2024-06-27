import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/globals.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/auth/login.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class RegistrationDetails extends ConsumerStatefulWidget {
  const RegistrationDetails(
      {super.key,
      required this.password,
      required this.email,
      required this.firebaseToken})
      : assert(password != "" && email != "");
  final String email, password, firebaseToken;
  @override
  ConsumerState<RegistrationDetails> createState() =>
      _RegistrationDetailsState();
}

class _RegistrationDetailsState extends ConsumerState<RegistrationDetails>
    with ColorPalette {
  final DataCacher _cacher = DataCacher.instance;
  final UserAuth _authApi = UserAuth();
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
      final List<GeoAddress> addresses =
          await Geocoder.google().findAddressesFromCoordinates(
        Coordinates(
          pos.latitude,
          pos.longitude,
        ),
      );
      if (addresses.isNotEmpty) {
        _address.text = addresses.first.addressLine ?? "NO ADDRESS FOUND";
        if (mounted) setState(() {});
      }
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
    final List<String> values = [
      _fname.text,
      _lname.text,
      _address.text,
    ];

    registerData(values, widget.firebaseToken);
    // widget.valueCallback(values);
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

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            width: size.width,
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
            child: SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              child: isLoading
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            logo(size.width * .1),
                            const Gap(10),
                            Text(
                              "ABLE ME",
                              style: fontTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            )
                          ],
                        ),
                        const Gap(30),
                        const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        const Gap(10),
                        Text(
                          "Please Wait",
                          style: fontTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const Gap(20),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                                color: textColor,
                              ),
                            )
                          ],
                        ),
                        const Gap(30),
                        Text(
                          "Details",
                          style: fontTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "Enter your personal informations to create an account.",
                          style: fontTheme.bodyMedium!.copyWith(
                            color: textColor.withOpacity(.5),
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
                                style: TextStyle(color: textColor),
                                focusNode: _fNode,
                                controller: _fname,
                                // autovalidateMode: AutovalidateMode.always,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),

                                onEditingComplete: () async {
                                  final bool isValidated =
                                      _kForm.currentState!.validate();
                                  if (isValidated) {
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
                                  //
                                  //   // await register();
                                  // }
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  hintText: "Firstname",
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(.5),
                                  ),
                                  label: const Text("Firstname"),
                                  labelStyle: TextStyle(
                                    color: textColor,
                                  ),
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
                              )
                                  .animate()
                                  .fadeIn(duration: 650.ms)
                                  .slideY(begin: 1, end: 0),
                              const Gap(10),
                              TextFormField(
                                style: TextStyle(color: textColor),
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
                                  final bool isValidated =
                                      _kForm.currentState!.validate();
                                  if (isValidated) {
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
                                  label: const Text("Lastname"),
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(.5),
                                  ),
                                  labelStyle: TextStyle(
                                    color: textColor,
                                  ),
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
                              )
                                  .animate()
                                  .fadeIn(duration: 700.ms)
                                  .slideY(begin: 1, end: 0),
                              const Gap(10),
                              TextFormField(
                                style: TextStyle(color: textColor),
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
                                  final bool isValidated =
                                      _kForm.currentState!.validate();
                                  if (isValidated) {
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
                                decoration: InputDecoration(
                                  isDense: false,
                                  hintText: "Address",
                                  // hintText: "⁕⁕⁕⁕⁕",
                                  label: const Text("Address"),
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(.5),
                                  ),
                                  labelStyle: TextStyle(
                                    color: textColor,
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 750.ms)
                                  .slideY(begin: 1, end: 0),
                            ],
                          ),
                        ),
                        const Gap(20),
                        Text.rich(
                          TextSpan(
                            text: "By creating an account, you agree to the ",
                            style: fontTheme.bodyMedium!.copyWith(
                              color: textColor.withOpacity(.5),
                              fontFamily: "Montserrat",
                            ),
                            children: [
                              TextSpan(
                                text: "Terms of use",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
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
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
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
                            final bool isValidated =
                                _kForm.currentState!.validate();
                            if (isValidated) {
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
                        )
                            .animate()
                            .fadeIn(duration: 700.ms)
                            .slideY(begin: 1, end: 0),
                        const SafeArea(
                          child: Gap(15),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerData(List<String> data, token) async {
    setState(() {
      isLoading = true;
    });
    await _authApi
        .register(
      email: widget.email,
      password: widget.password,
      name: data.first,
      lastName: data[1],
      accountType: 1,
      firebaseToken: token,
    )
        .then((value) async {
      if (value == null) {
        isLoading = false;
        if (mounted) setState(() {});
        return;
      }
      isLoading = false;
      if (mounted) setState(() {});
      ref.watch(accessTokenProvider.notifier).update((state) => value);
      _cacher.setUserToken(value);
      //ignore: use_build_context_synchronously
      context.pushReplacement(
        '/landing-page',
      );
    });

    return;
  }
}
