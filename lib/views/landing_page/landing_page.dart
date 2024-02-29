import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/auth/auth_helper.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/services/geolocation_service.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/views/landing_page/children/community_page.dart';
import 'package:able_me/views/landing_page/children/history_page.dart';
import 'package:able_me/views/landing_page/children/home_page.dart';
import 'package:able_me/views/landing_page/children/profile_page.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key, required this.initIndex});
  final int initIndex;
  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage>
    with ColorPalette, AuthHelper, GeoLocationService {
  late int currentIndex = widget.initIndex;
  late final PageController _controller =
      PageController(initialPage: currentIndex);
  late final List<Widget> content = [
    HomePage(
      onPageRequest: (i) {
        setState(() {
          currentIndex = i;
        });
        _controller.animateToPage(currentIndex,
            duration: 300.ms, curve: Curves.fastLinearToSlowEaseIn);
      },
    ),
    const CommunityPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];
  // List<GeoAddress> currentAddress = [];
  // final Geocoder _geocoder = Geocoder();
  Position? pos;
  Future<void> receivedValue(Position p) async {
    // ref.read(coordinateProvider).
    if (pos == null) {
      print("null point");
      pos = p;
      if (mounted) setState(() {});
    }
    final double dist =
        distance(pos!.latitude, pos!.longitude, p.latitude, p.longitude);
    print("DISTANCE IN METERS : ${dist * 1000}");
    if ((dist * 1000) < 1) return;
    print("DISTANCE : $dist");
    print("PREV : ${pos!}");
    print("CURR : $p");
    // if()

    print("POSITION ${p.toString()}");
    // currentAddress = await Geocoder.google().findAddressesFromCoordinates(
    //   Coordinates(p.latitude, p.longitude),
    // );

    // print(currentAddress);
    pos = p;
    if (mounted) setState(() {});
  }

  Future<void> initialize(int time) async {
    // Geocoder.google().
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Geolocator.getPositionStream().listen((event) async {
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

  @override
  void initState() {
    // TODO: implement initState
    initialize(0);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String? token = ref.read(accessTokenProvider.notifier).state;
      if (token == null) {
        context.replaceNamed('/');
      }
      final UserModel? udata = await getUserData(token!);
      if (udata == null) {
        Fluttertoast.showToast(msg: "Account is incomplete");
        print("GO TO REGISTER DETAILS PAGE");
        return;
      }
      ref.read(currentUser.notifier).update((state) => udata);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            // onPageChanged: (g) {
            //   setState(() {
            //     currentIndex = g;
            //   });
            // },
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            // physics: const ClampingScrollPhysics(),
            children: content,
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: context.theme.bottomNavigationBarTheme.backgroundColor!,
            index: currentIndex,
            onTap: (i) {
              setState(() {
                currentIndex = i;
              });
              _controller.animateToPage(currentIndex,
                  duration: 400.ms, curve: Curves.linear);
            },
            buttonBackgroundColor: context.theme.colorScheme.background,
            backgroundColor: Colors.transparent,
            items: [
              SizedBox(
                height: 30,
                width: 30,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/home.svg",
                    color: currentIndex == 0
                        ? Colors.white
                        : context.theme.secondaryHeaderColor.withOpacity(.5),
                  ),
                ),
              ),
              SvgPicture.asset(
                "assets/icons/community.svg",
                width: 30,
                color: currentIndex == 1
                    ? Colors.white
                    : context.theme.secondaryHeaderColor.withOpacity(.5),
              ),
              SizedBox(
                height: 30,
                width: 30,
                // padding: const EdgeInsets.all(2),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/history.svg",
                    width: 20,
                    color: currentIndex == 2
                        ? Colors.white
                        : context.theme.secondaryHeaderColor.withOpacity(.5),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/profile.svg",
                    color: currentIndex == 3
                        ? Colors.white
                        : context.theme.secondaryHeaderColor.withOpacity(.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    // return _data.when(
    //   error: (error, r) => Scaffold(
    //     body: Center(
    //       child: Column(
    //         children: [Text("ERROR : $r")],
    //       ),
    //     ),
    //   ),
    //   loading: () => ,
    // );
    // return ;
  }
}
