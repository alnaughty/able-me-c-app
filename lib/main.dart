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

// Completer<AndroidMapRenderer?>? _initializedRendererCompleter;

/// Initializes map renderer to the `latest` renderer type for Android platform.
///
/// The renderer must be requested before creating GoogleMap instances,
/// as the renderer can be initialized only once per application context.
// Future<AndroidMapRenderer?> initializeMapRenderer() async {
//   if (_initializedRendererCompleter != null) {
//     return _initializedRendererCompleter!.future;
//   }

//   final Completer<AndroidMapRenderer?> completer =
//       Completer<AndroidMapRenderer?>();
//   _initializedRendererCompleter = completer;

//   WidgetsFlutterBinding.ensureInitialized();

//   final GoogleMapsFlutterPlatform mapsImplementation =
//       GoogleMapsFlutterPlatform.instance;
//   if (mapsImplementation is GoogleMapsFlutterAndroid) {
//     unawaited(mapsImplementation
//         .initializeWithRenderer(AndroidMapRenderer.latest)
//         .then((AndroidMapRenderer initializedRenderer) =>
//             completer.complete(initializedRenderer)));
//   } else {
//     completer.complete(null);
//   }

//   return completer.future;
// }
