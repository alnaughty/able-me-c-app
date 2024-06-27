import 'dart:async';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';

class AbleMeMapPicker extends ConsumerStatefulWidget {
  const AbleMeMapPicker({super.key, required this.geoPointCallback});
  final ValueChanged<GeoPoint> geoPointCallback;
  @override
  ConsumerState<AbleMeMapPicker> createState() => _AbleMeMapPickerState();
}

class _AbleMeMapPickerState extends ConsumerState<AbleMeMapPicker>
    with ColorPalette {
  bool showLocation = true;
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  final TextEditingController textController = TextEditingController();
  CameraPosition? cameraPosition;

  @override
  Widget build(BuildContext context) {
    final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            // pass icon widget
            iconWidget: Image.asset(
              "assets/icons/party-location.gif",
              height: 60,
              color: purplePalette,
            ),
            // iconWidget: SvgPicture.asset(
            //   "assets/icons/location.svg",
            //   color: purplePalette,
            //   height: 60,
            // ),

            //add map picker controller
            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: false,
              zoomControlsEnabled: false,

              // hide location button
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              //  camera position
              initialCameraPosition: CameraPosition(
                target: LatLng(userLoc!.latitude, userLoc.longitude),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                setState(() {
                  cameraPosition = CameraPosition(
                    target: LatLng(userLoc.latitude, userLoc.longitude),
                    zoom: 15,
                  );
                });
              },
              onCameraMoveStarted: () {
                // notify map is moving
                mapPickerController.mapMoving!();
                textController.text = "checking ...";
                setState(() {
                  showLocation = false;
                });
              },
              onCameraMove: (c) {
                cameraPosition = c;
              },
              onCameraIdle: () async {
                // notify map stopped moving
                mapPickerController.mapFinishedMoving!();
                //get address name from camera position
                List<GeoAddress> placemarks =
                    await Geocoder.google().findAddressesFromGeoPoint(
                  GeoPoint(cameraPosition!.target.latitude,
                      cameraPosition!.target.longitude),
                );
                setState(() {
                  showLocation = true;
                });
                // update the ui with the address
                textController.text =
                    '${placemarks.first.featureName}, ${placemarks.first.locality}, ${placemarks.first.countryName}';
              },
            ),
          ),
          // Positioned(
          //   top: MediaQuery.of(context).viewPadding.top + 20,
          //   width: MediaQuery.of(context).size.width - 50,
          //   // height: 50,
          //   child: AnimatedContainer(
          //     duration: 1000.ms,
          //     decoration: BoxDecoration(
          //         color: showLocation
          //             ? purplePalette.withOpacity(.2)
          //             : Colors.transparent,
          //         borderRadius: BorderRadius.circular(60)),
          //     padding: const EdgeInsets.all(15),
          //     child: Text(
          //       textController.text,
          //       style: TextStyle(
          //         color: showLocation ? Colors.grey.shade900 : purplePalette,
          //       ),
          //     ),
          //     // child: TextFormField(
          //     //   textAlign: TextAlign.center,
          //     //   readOnly: true,
          //     //   keyboardType: TextInputType.multiline,
          //     //   maxLines: null,
          //     //   decoration: const InputDecoration(
          //     //       contentPadding: EdgeInsets.zero, border: InputBorder.none),
          //     //   controller: textController,
          //     // ),
          //   ),
          // ),
          Positioned(
            top: 0,
            left: 20,
            child: SafeArea(
                child: BackButton(
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.resolveWith(
                    (states) => const Size(65, 65)),
                backgroundColor: WidgetStateProperty.resolveWith(
                    (states) => purplePalette.withOpacity(.8)),
                shape: WidgetStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              color: Colors.white,
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
            )),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            if (showLocation) ...{
                              Image.asset(
                                "assets/images/mockup_vectors/location.png",
                                width: 50,
                              ),
                              const Gap(10)
                            },
                            Expanded(
                              child: Text(
                                textController.text.isEmpty
                                    ? "No location pinned"
                                    : textController.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(15),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white
                  //   ),
                  // ),
                  MaterialButton(
                    height: 60,
                    color: purplePalette,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.geoPointCallback(
                        GeoPoint(
                          cameraPosition!.target.latitude,
                          cameraPosition!.target.longitude,
                        ),
                      );
                    },
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
              ),
            ),
            // child: SizedBox(
            //   height: 50,
            //   child: TextButton(
            //     onPressed: () {
            //       // print(
            //       //     "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
            //       //
            //     },
            //     style: ButtonStyle(
            //       backgroundColor:
            //           MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
            //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //         RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(15.0),
            //         ),
            //       ),
            //     ),
            //     child: const Text(
            //       "Submit",
            //       style: TextStyle(
            //         fontWeight: FontWeight.w400,
            //         fontStyle: FontStyle.normal,
            //         color: Color(0xFFFFFFFF),
            //         fontSize: 19,
            //         // height: 19/19,
            //       ),
            //     ),
            //   ),
            // ),
          )
        ],
      ),
    );
  }
}
