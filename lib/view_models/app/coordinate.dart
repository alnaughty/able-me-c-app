import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final coordinateProvider = Provider<Position?>((ref) => null);
