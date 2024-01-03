import 'package:able_me/app_config/palette.dart';
import 'package:able_me/app_config/routes.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AbleMeApp extends StatelessWidget with ColorPalette {
  AbleMeApp({Key? key}) : super(key: key);
  static final RouteConfig _config = RouteConfig.instance;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Able Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F3F3),
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSwatch(primarySwatch: greenPalette),
        useMaterial3: true,

        // for textfield decoration
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide(
              width: .5,
              color: Colors.black.withOpacity(.5),
            ),
          ),
        ),
      ),
      routerConfig: _config.router,
    );
  }
}
