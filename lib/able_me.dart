import 'package:able_me/app_config/palette.dart';
import 'package:able_me/app_config/routes.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class AbleMeApp extends StatelessWidget with ColorPalette {
  AbleMeApp({Key? key}) : super(key: key);
  static final RouteConfig _config = RouteConfig.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var darkMode = ref.watch(darkModeProvider);
        return MaterialApp.router(
          title: 'Able Me',
          debugShowCheckedModeBanner: false,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData(
            appBarTheme: const AppBarTheme(
                color: Color.fromARGB(255, 13, 13, 13),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                titleTextStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            switchTheme: SwitchThemeData(
              thumbColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white),
              trackOutlineColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent),
              trackColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.grey.shade300),
              overlayColor:
                  MaterialStateProperty.resolveWith((states) => greenPalette),
            ),
            fontFamily: "Montserrat",
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.grey.shade900,
            ),
            scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
            secondaryHeaderColor: const Color(0xFFF3F3F3),
            primaryColor: const Color.fromARGB(255, 8, 8, 8),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: purplePalette,
              backgroundColor: purplePalette.shade500,
              accentColor: orange,
            ),
            cardColor: Colors.grey.shade900,
            checkboxTheme: CheckboxThemeData(
              side: const BorderSide(color: Colors.white),
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => purplePalette.withOpacity(.3)),
              checkColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white),
              fillColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent),
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              isDense: true,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 0.5, color: Colors.grey.shade800),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 2,
                  color: purplePalette,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.white.withOpacity(.5),
                ),
              ),
            ),
          ),
          theme: ThemeData(
            appBarTheme: AppBarTheme(
                color: const Color.fromARGB(255, 255, 255, 255),
                iconTheme: IconThemeData(
                  color: Colors.grey.shade900,
                ),
                titleTextStyle: const TextStyle(
                  color: Color.fromARGB(255, 13, 13, 13),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            switchTheme: SwitchThemeData(
              thumbColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white),
              trackOutlineColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent),
              trackColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.grey.shade300),
              overlayColor:
                  MaterialStateProperty.resolveWith((states) => greenPalette),
            ),
            scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
            checkboxTheme: CheckboxThemeData(
              side: const BorderSide(color: Color.fromARGB(255, 18, 18, 18)),
              overlayColor: MaterialStateProperty.resolveWith(
                  (states) => purplePalette.withOpacity(.3)),
              checkColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white),
              fillColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent),
            ),
            secondaryHeaderColor: const Color.fromARGB(255, 18, 18, 18),
            primaryColor: const Color(0xFFF3F3F3),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
            ),
            fontFamily: "Montserrat",
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: greenPalette,
              backgroundColor: greenPalette.shade500,
              accentColor: blue,
            ),
            cardColor: Colors.grey.shade200,
            useMaterial3: true,

            // for textfield decoration
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              isDense: true,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 0.5, color: Colors.grey.shade400),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 2,
                  color: purplePalette,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(.5),
                ),
              ),
            ),
          ),
          routerConfig: _config.router,
        );
      },
      // child: ,
    );
  }
}
