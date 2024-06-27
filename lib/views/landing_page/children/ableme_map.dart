import 'dart:async';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/firebase_user_location_model.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/notifiers/user_location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AbleMeMapPage extends ConsumerStatefulWidget {
  const AbleMeMapPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AbleMeMapPageState();
}

class _AbleMeMapPageState extends ConsumerState<AbleMeMapPage>
    with ColorPalette {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
        final List<FirebaseUserLocation> data = ref.watch(userLocationProvider);

        return Scaffold(
          backgroundColor: Colors.white,
          body: GoogleMap(
            style: "asdada",
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                userLoc!.latitude,
                userLoc.longitude,
              ),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            circles: <Circle>{
              Circle(
                center: LatLng(
                  userLoc.latitude,
                  userLoc.longitude,
                ),
                radius: 1000,
                strokeWidth: 2,
                strokeColor: purplePalette,
                fillColor: purplePalette.withOpacity(.3),
                circleId: const CircleId("my-range"),
              )
            },
            markers: <Marker>{
              Marker(
                markerId: const MarkerId("me"),
                position: LatLng(
                  userLoc.latitude,
                  userLoc.longitude,
                ),
                infoWindow: InfoWindow(
                  title: "My Location",
                  snippet: userLoc.toString(),
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet,
                ),
              ),
              ...data.map(
                (e) => Marker(
                  markerId: MarkerId(e.fullname),
                  position: LatLng(
                    userLoc.latitude + .002,
                    userLoc.longitude,
                  ),
                  infoWindow: InfoWindow(
                    title: e.fullname.capitalizeWords(),
                    snippet: e.coordinates.toString(),
                  ),
                ),
              ),
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.pop();
            },
            label: const Text('Back'),
            icon: const Icon(Icons.keyboard_backspace_outlined),
          ),
        );
      },
      // child: ,
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
