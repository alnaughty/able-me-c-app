import 'package:able_me/able_me.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  final DataCacher _cacher = DataCacher.instance;

  WidgetsFlutterBinding.ensureInitialized();
  // final GoogleMapsFlutterPlatform mapsImplementation =
  //     GoogleMapsFlutterPlatform.instance;
  // if (mapsImplementation is GoogleMapsFlutterAndroid) {
  //   mapsImplementation.useAndroidViewSurface = true;
  //   mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
  //   // initializeMapRenderer();
  // }
  await _cacher.init();
  // _cacher.removeToken();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      child: AbleMeApp(),
    ),
  );
}
