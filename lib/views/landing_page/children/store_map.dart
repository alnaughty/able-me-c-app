import 'dart:async';

import 'package:able_me/app_config/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreMapPage extends StatefulWidget {
  const StoreMapPage({super.key, required this.coordinates});
  final GeoPoint coordinates;
  @override
  State<StoreMapPage> createState() => _StoreMapPageState();
}

class _StoreMapPageState extends State<StoreMapPage> with ColorPalette {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      trafficEnabled: true,
      liteModeEnabled: false,
      buildingsEnabled: true,
      indoorViewEnabled: false,
      mapToolbarEnabled: false,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      fortyFiveDegreeImageryEnabled: false,
      // hide location button
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      markers: {
        Marker(
            markerId: MarkerId(
              "${widget.coordinates}",
            ),
            position: LatLng(
              widget.coordinates.latitude,
              widget.coordinates.longitude,
            ))
      },
      //  camera position
      initialCameraPosition: CameraPosition(
        target:
            LatLng(widget.coordinates.latitude, widget.coordinates.longitude),
        zoom: 15,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
