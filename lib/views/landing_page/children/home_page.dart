import 'package:able_me/views/landing_page/children/home_page_components/recent_booking.dart';
import 'package:able_me/views/landing_page/children/home_page_components/suggested_driver_page.dart';
import 'package:able_me/views/widget_components/badged_icon.dart';
import 'package:able_me/views/widget_components/carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onPageRequest});
  final ValueChanged<int> onPageRequest;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 70,
        centerTitle: false,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "John Doe",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "20 Auburn Road,Canberra, 4413, Australia",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
        // title: ListTile(),
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        actions: const [
          BadgedIcon(
            isBadged: true,
            iconPath: "assets/icons/chats.svg",
          ),
          BadgedIcon(
            isBadged: true,
            iconPath: "assets/icons/notif.svg",
            iconSize: 25,
          ),
        ],
        leading: Container(
          margin: const EdgeInsets.only(
            left: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 0,
        ),
        children: [
          const Gap(20),
          CarouselWidget(
            height: size.height * .25,
          ),
          const Gap(15),
          RecentBookingPage(
            onViewAll: () {
              widget.onPageRequest(2);
            },
          ),
          const Gap(15),
          SuggestedDriverPage(),
          const SafeArea(
            top: false,
            child: Gap(10),
          ),
        ],
      ),
    );
  }
}
