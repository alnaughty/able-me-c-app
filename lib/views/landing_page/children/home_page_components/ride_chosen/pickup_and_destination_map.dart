import 'dart:async';
import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/geo_point_ext.dart';
import 'package:able_me/helpers/widget/custom_marker.dart';
import 'package:able_me/helpers/widget/image_as_marker.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/app_src/env_service.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class PickupAndDestMap extends ConsumerStatefulWidget {
  const PickupAndDestMap(
      {super.key,
      required this.destination,
      required this.size,
      this.pickUpLocation});
  final GeoPoint? destination;
  final double size;
  final GeoPoint? pickUpLocation;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickupAndDestMapState();
}

class _PickupAndDestMapState extends ConsumerState<PickupAndDestMap>
    with ColorPalette {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initAddMarker();
      if (widget.destination != null) {
        await initPolyline();
      }
    });
    super.initState();
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  final EnvService _env = EnvService.instance;
  Future<void> initPolyline() async {
    final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
    List<GeoAddress> address =
        await Geocoder.google().findAddressesFromGeoPoint(
      widget.pickUpLocation ?? GeoPoint(userLoc!.latitude, userLoc.longitude),
    );
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      // Platform.isAndroid ? "" : "",
      _env.mapApiKey,
      widget.pickUpLocation != null
          ? PointLatLng(
              widget.pickUpLocation!.latitude, widget.pickUpLocation!.longitude)
          : PointLatLng(userLoc!.latitude, userLoc.longitude),
      PointLatLng(widget.destination!.latitude, widget.destination!.longitude),
      travelMode: TravelMode.driving,
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

  Future<void> initAddMarker() async {
    final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
    final UserModel? _currentUser = ref.watch(currentUser);
    final Marker marker = Marker(
      markerId: const MarkerId("me"),
      position: widget.pickUpLocation != null
          ? LatLng(
              widget.pickUpLocation!.latitude,
              widget.pickUpLocation!.longitude,
            )
          : LatLng(
              userLoc!.latitude,
              userLoc.longitude,
            ),
      infoWindow: const InfoWindow(
        title: "Pickup",
      ),
      icon: await ImageAsMarker(
        fullname: _currentUser!.fullname,
        networkImage: _currentUser.avatar,
      ).toBitmapDescriptor(),
    );
    if (widget.destination != null) {
      final Marker m = Marker(
        markerId: const MarkerId("dest"),
        position: LatLng(
          widget.destination!.latitude,
          widget.destination!.longitude,
        ),
        infoWindow: const InfoWindow(
          title: "Destination",
        ),
        icon: await const CustomMarkerAbleMe().toBitmapDescriptor(),
      );
      markers.add(m);
    }
    markers.add(marker);
    if (mounted) setState(() {});
  }
  // LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  //   final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
  //   return LatLngBounds(
  //     northeast:
  //         LatLng(widget.destination!.latitude, widget.riderPoint.longitude),
  //     southwest: LatLng(userLoc!.latitude, userLoc.longitude),
  //   );
  // }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    final Position? userLoc = ref.watch(coordinateProvider.notifier).state;

    return SizedBox(
      width: context.csize!.width,
      height: widget.size,
      child: GoogleMap(
        mapType: MapType.normal,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        rotateGesturesEnabled: false,
        buildingsEnabled: false,
        myLocationButtonEnabled: false,
        tiltGesturesEnabled: false,
        layoutDirection: TextDirection.rtl,
        mapToolbarEnabled: false,
        fortyFiveDegreeImageryEnabled: false,
        trafficEnabled: false,
        myLocationEnabled: false,
        liteModeEnabled: Platform.isAndroid,
        initialCameraPosition: CameraPosition(
          target: widget.pickUpLocation != null
              ? LatLng(
                  widget.pickUpLocation!.latitude,
                  widget.pickUpLocation!.longitude,
                )
              : LatLng(
                  userLoc!.latitude,
                  userLoc.longitude,
                ),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          if (widget.destination == null) {
            // controller.animateCamera(cameraUpdate)
            await controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                widget.pickUpLocation != null
                    ? LatLng(
                        widget.pickUpLocation!.latitude,
                        widget.pickUpLocation!.longitude,
                      )
                    : LatLng(
                        userLoc!.latitude,
                        userLoc.longitude,
                      ),
                20,
              ),
            );
            return;
          }
          final LatLngBounds f = getLatLngBounds([
            LatLng(widget.destination!.latitude, widget.destination!.longitude),
            widget.pickUpLocation != null
                ? LatLng(
                    widget.pickUpLocation!.latitude,
                    widget.pickUpLocation!.longitude,
                  )
                : LatLng(
                    userLoc!.latitude,
                    userLoc.longitude,
                  )
          ]);
          CameraUpdate cu = CameraUpdate.newLatLngBounds(f, 120);
          await controller.animateCamera(cu);
        },
        markers: {
          ...markers,
          // if (widget.destination != null) ...{
          //   Marker(
          //     markerId: const MarkerId("rider"),
          //     position: LatLng(
          //       widget.destination!.latitude,
          //       widget.destination!.longitude,
          //     ),
          //     infoWindow: const InfoWindow(
          //       title: "Destination",
          //     ),
          //     icon: BitmapDescriptor.defaultMarkerWithHue(
          //       BitmapDescriptor.hueBlue,
          //     ),
          //   ),
          // }
        },
        polylines: Set<Polyline>.of(polylines.values),
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
      width: 2,
      polylineId: id,
      patterns: [PatternItem.dash(10), PatternItem.gap(5)],
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
