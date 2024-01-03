import 'package:able_me/app_config/palette.dart';
import 'package:able_me/views/landing_page/children/community_page.dart';
import 'package:able_me/views/landing_page/children/history_page.dart';
import 'package:able_me/views/landing_page/children/home_page.dart';
import 'package:able_me/views/landing_page/children/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.initIndex});
  final int initIndex;
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with ColorPalette {
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
  @override
  Widget build(BuildContext context) {
    print(currentIndex);
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
        index: currentIndex,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
          _controller.animateToPage(currentIndex,
              duration: 400.ms, curve: Curves.linear);
        },
        buttonBackgroundColor: greenPalette,
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
                    : Colors.black.withOpacity(.5),
              ),
            ),
          ),
          SvgPicture.asset(
            "assets/icons/community.svg",
            width: 30,
            color:
                currentIndex == 1 ? Colors.white : Colors.black.withOpacity(.5),
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
                    : Colors.black.withOpacity(.5),
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
                    : Colors.black.withOpacity(.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
