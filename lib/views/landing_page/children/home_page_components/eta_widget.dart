import 'dart:convert';
import 'package:able_me/services/app_src/env_service.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ETAWidget extends ConsumerStatefulWidget {
  ETAWidget(
      {Key? key,
      required this.riderPoint,
      this.additionalText,
      this.style,
      this.loadingText})
      : super(key: key);
  final GeoPoint riderPoint;
  final String? additionalText;
  final TextStyle? style;
  final String? loadingText;
  @override
  _ETAWidgetState createState() => _ETAWidgetState();
}

class _ETAWidgetState extends ConsumerState<ETAWidget> {
  final EnvService _env = EnvService.instance;

  String? eta;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await calculateETA();
    });
    super.initState();
  }

  Future<void> calculateETA() async {
    print("calc");
    final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
    if (userLoc == null) return;
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.riderPoint.latitude},${widget.riderPoint.longitude}&destination=${userLoc.latitude},${userLoc.longitude}&key=${_env.mapApiKey}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        eta = data['routes'][0]['legs'][0]['duration']['text'];
      });
    } else {
      throw Exception('Failed to load ETA');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        eta == null
            ? widget.loadingText ?? 'Calculating ETA...'
            : "$eta ${widget.additionalText ?? ""}",
        style: widget.style ?? const TextStyle(color: Colors.white),
      ),
    );
  }
}
