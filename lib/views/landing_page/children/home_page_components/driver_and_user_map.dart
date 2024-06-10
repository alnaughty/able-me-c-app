import 'dart:async';
import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/app_src/env_service.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverAndUserMap extends ConsumerStatefulWidget {
  const DriverAndUserMap({super.key, required this.riderPoint});
  final GeoPoint riderPoint;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DriverAndUserMapState();
}

class _DriverAndUserMapState extends ConsumerState<DriverAndUserMap>
    with ColorPalette {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initPolyline();
    });
    super.initState();
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  final EnvService _env = EnvService.instance;
  Future<void> initPolyline() async {
    final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
    List<GeoAddress> address =
        await Geocoder.google().findAddressesFromGeoPoint(
      GeoPoint(userLoc!.latitude, userLoc.longitude),
    );
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      // Platform.isAndroid ? "" : "",
      _env.mapApiKey,
      PointLatLng(userLoc!.latitude, userLoc.longitude),
      PointLatLng(widget.riderPoint.latitude, widget.riderPoint.longitude),
      travelMode: TravelMode.transit,
      optimizeWaypoints: true,
    );
    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      if (mounted) setState(() {});
      _addPolyLine();
    }
    print(result.points);
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
    return LatLngBounds(
      northeast:
          LatLng(widget.riderPoint.latitude, widget.riderPoint.longitude),
      southwest: LatLng(userLoc!.latitude, userLoc.longitude),
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: context.csize!.width,
        height: context.csize!.height * .25,
        child: GoogleMap(
          mapType: MapType.normal,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
          zoomControlsEnabled: false,
          rotateGesturesEnabled: false,
          buildingsEnabled: false,
          myLocationButtonEnabled: false,
          tiltGesturesEnabled: false,
          layoutDirection: TextDirection.rtl,
          mapToolbarEnabled: false,
          fortyFiveDegreeImageryEnabled: false,
          trafficEnabled: true,
          myLocationEnabled: false,
          liteModeEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.riderPoint.latitude,
              widget.riderPoint.longitude,
            ),
            zoom: widget.riderPoint.distanceBetween(
                  userLoc!,
                ) *
                100000,
          ),
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            final LatLngBounds f = getLatLngBounds([
              LatLng(widget.riderPoint.latitude, widget.riderPoint.longitude),
              LatLng(userLoc.latitude, userLoc.longitude)
            ]);
            CameraUpdate cu = CameraUpdate.newLatLngBounds(f, 50);
            await controller.animateCamera(cu);
          },
          markers: {
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
            Marker(
              markerId: const MarkerId("rider"),
              position: LatLng(
                widget.riderPoint.latitude,
                widget.riderPoint.longitude,
              ),
              infoWindow: InfoWindow(
                title: "Rider Location",
                snippet:
                    "${widget.riderPoint.latitude} - ${widget.riderPoint.longitude}",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
          },
          polylines: Set<Polyline>.of(polylines.values),
        ),
      ),
    );
  }

  Future<void> updateCamera() async {
    // final GoogleMapController controller = await _controller.future;

    // await controller
    //     .animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      width: 5,
      polylineId: id,
      color: purplePalette,
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  // void check(CameraUpdate u, GoogleMapController c) async {
  //   final GoogleMapController controller = await _controller.future;
  //   c.animateCamera(u);
  //   controller.animateCamera(u);
  //   LatLngBounds l1 = await c.getVisibleRegion();
  //   LatLngBounds l2 = await c.getVisibleRegion();
  //   print(l1.toString());
  //   print(l2.toString());
  //   if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
  //     check(u, c);
  // }
  static LatLngBounds getLatLngBounds(List<LatLng> list) {
    double x0 = 0.0;
    double x1 = 0.0;
    double y0 = 0.0;
    double y1 = 0.0;
    for (final latLng in list) {
      if (x0 == 0.0) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }
}
