import 'dart:io';
import 'dart:isolate';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/auth/auth_helper.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/app_src/speech_recgonition.dart';
import 'package:able_me/services/firebase/user_location_service.dart';
import 'package:able_me/services/geolocation_service.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/notifiers/user_location_state_notifier.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/history_page.dart';
import 'package:able_me/views/landing_page/children/profile_page.dart';
import 'package:able_me/views/landing_page/children/restaurant_page_components/main_restaurant_page.dart';
import 'package:able_me/views/landing_page/children/transportation_page_components/main_transportation_page.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key, required this.initIndex});
  final int initIndex;
  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage>
    with ColorPalette, AuthHelper, GeoLocationService {
  static final UserLocationFirebaseService _locationFirebaseService =
      UserLocationFirebaseService();
  late final MySpeechRecognitionAssistant _mySpeechRecognition =
      MySpeechRecognitionAssistant.initialize([
    _kTranspo,
  ], currentIndex);
  final GlobalKey<MainTransportationPageState> _kTranspo =
      GlobalKey<MainTransportationPageState>();
  FlutterIsolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;
  bool hasListened = false;
  late int currentIndex = widget.initIndex;
  late final PageController _controller =
      PageController(initialPage: currentIndex);
  late final List<Widget> content = [
    MainTransportationPage(
      key: _kTranspo,
    ),
    const MainRestaurantPage(),
    const HistoryPage(),
    const ProfilePage(),
    Container(
      color: Colors.red,
    ),
  ];

  Future<void> receivedValue(Position p) async {
    Position? pos = ref.read(coordinateProvider);

    final bool isNew = pos == null;
    if (pos == null) {
      print("null point");
      pos = p;
      if (mounted) setState(() {});
    }
    final double dist =
        distance(pos.latitude, pos.longitude, p.latitude, p.longitude);
    ref.read(coordinateProvider.notifier).update((state) => p);

    if ((dist * 1000) < (Platform.isAndroid ? 2 : 1) && !isNew) return;

    final User? user = FirebaseAuth.instance.currentUser;
    final UserModel? _currentUser = ref.watch(currentUser);

    if (user == null || _currentUser == null) return;

    _locationFirebaseService.updateOrCreateUserLocation(
      user,
      Coordinates(
        pos.latitude,
        pos.longitude,
      ),
      _currentUser,
    );
    hasListened = false;

    print("POSITION ${p.toString()}");

    if (mounted) setState(() {});
  }

  Future<void> initialize(int time) async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Geolocator.getPositionStream().listen((event) async {
        if (udata != null) {
          print('fetch');
          _service
              .driverLocationCollectionStream(udata!, event)
              .listen((event) {
            ref.watch(userLocationProvider.notifier).update(event);
          });

          hasListened = true;
          if (mounted) setState(() {});
        }

        await receivedValue(event);
      });
    } else {
      print("FF");
      final LocationPermission perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse) {
        await initialize(time++);
      } else {
        await Fluttertoast.showToast(
          msg: "Please enable location permission to use the app",
        );
        if (time > 1) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }
      }
    }
  }

  UserModel? udata;
  final UserLocationFirebaseService _service = UserLocationFirebaseService();
  @override
  void initState() {
    initialize(0);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String? token = ref.read(accessTokenProvider.notifier).state;
      if (token == null) {
        context.replaceNamed('/');
      }
      await getUserData(token!).then((value) {
        ref.read(currentUser.notifier).update((state) => value);
        setState(() {
          udata = value;
        });
        print("ACCOUNT VALUE : $udata");
        if (value == null) {
          Fluttertoast.showToast(msg: "Account is incomplete");
          print("GO TO REGISTER DETAILS PAGE");
          return;
        }
      });
      await _mySpeechRecognition.initPlatform2(
        (value) {
          if (value < 0) {
            exit(0);
          }
          currentIndex = value;
          setState(() {});
          _controller.jumpToPage(currentIndex);
        },
        SpeechToText(),
        FlutterTts(),
        _sendPort!,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final stream = ref.watch(currentUser.notifier).stream;

    return StreamBuilder(
      stream: stream,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: FullScreenLoader(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [Text("ERROR : ${snapshot.error}")],
            ),
          );
        }
        return Scaffold(
          extendBody: true,
          body: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: content,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: currentIndex == 4
                ? purplePalette
                : isDarkMode
                    ? bgColor.lighten()
                    : bgColor.darken(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            onPressed: () {
              setState(() {
                currentIndex = 4;
              });
              _controller.jumpToPage(
                currentIndex,
              );
            },
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                width: 30,
                color: currentIndex == 4 ? Colors.white : null,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: isDarkMode ? bgColor.lighten() : bgColor.darken(),
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                      _controller.animateToPage(
                        currentIndex,
                        duration: 600.ms,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/nav_icons/car.svg",
                        width: 20,
                        color: currentIndex == 0
                            ? purplePalette
                            : textColor.withOpacity(.4),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                      _controller.animateToPage(
                        currentIndex,
                        duration: 600.ms,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/nav_icons/food.svg",
                        width: 20,
                        color: currentIndex == 1
                            ? purplePalette
                            : textColor.withOpacity(.4),
                      ),
                    ),
                  ),
                ),
                const Gap(75),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = 2;
                      });
                      _controller.animateToPage(
                        currentIndex,
                        duration: 600.ms,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/nav_icons/doctor.svg",
                        width: 20,
                        color: currentIndex == 2
                            ? purplePalette
                            : textColor.withOpacity(.4),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = 3;
                      });
                      _controller.animateToPage(
                        currentIndex,
                        duration: 600.ms,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/nav_icons/parcel.svg",
                        width: 20,
                        color: currentIndex == 3
                            ? purplePalette
                            : textColor.withOpacity(.4),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
