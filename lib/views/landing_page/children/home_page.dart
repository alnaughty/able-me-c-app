import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/views/landing_page/children/home_page_components/foods/browse_restaurants.dart';
import 'package:able_me/views/landing_page/children/home_page_components/home_page_header.dart';
import 'package:able_me/views/landing_page/children/home_page_components/medicine/browse_pharmacy.dart';
import 'package:able_me/views/widget_components/badged_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.onPageRequest});
  final ValueChanged<int> onPageRequest;
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with ColorPalette {
  @override
  void initState() {
    // TODO: implement initState
    // initialize();
    print('init home page');
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await ;
    //   // print();
    // });
    super.initState();
  }

  int restaurantCount = 20;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserModel? _udata = ref.watch(currentUser.notifier).state;
    final Position? pos = ref.watch(coordinateProvider);
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Scaffold(
      // appBar: ,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                backgroundColor: purplePalette,
                elevation: 0,
                automaticallyImplyLeading: false,
                leadingWidth: 70,

                flexibleSpace: Container(
                  padding: const EdgeInsets.only(top: 95),
                  // color: purplePalette,
                  // height: 300,
                  child: const HomeHeader(),
                ),
                centerTitle: false,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "${_udata?.fullname.capitalizeWords() ?? ""}!",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // if (currentAddress.isNotEmpty) ...{

                    // },
                  ],
                ),
                // title: ListTile(),
                // backgroundColor: Colors.transparent,
                toolbarHeight: 60,
                actions: const [
                  BadgedIcon(
                    isBadged: true,
                    color: Colors.white,
                    iconPath: "assets/icons/chats.svg",
                  ),
                  BadgedIcon(
                    isBadged: true,
                    color: Colors.white,
                    iconPath: "assets/icons/notif.svg",
                    iconSize: 25,
                  ),
                ],
                leading: Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(
                    left: 15,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    // border: Border.all(
                    //   color: Colors.white,
                    //   width: 3,
                    // ),
                    // image: DecorationImage(image: _udata?.avatar == null ? AssetImage("assets/images/logo.png") : NetworkImage(_udata!.avatar))
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => widget.onPageRequest(3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _udata == null
                            ? Container(
                                width: 45,
                                height: 45,
                                color: Colors.grey.shade100,
                                child: Image.asset(
                                  "assets/images/logo.png",
                                ),
                              )
                            : Container(
                                width: 45,
                                height: 45,
                                color: _udata.avatar == null
                                    ? context.theme.colorScheme.background
                                    : Colors.white,
                                child: _udata.avatar == null
                                    ? Center(
                                        child: Text(
                                          _udata.fullname[0].toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: context.fontTheme
                                                    .bodyLarge!.fontSize! +
                                                5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: _udata.avatar!),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(20),
            const BrowseRestaurantsDisplay(),
            const Gap(20),
            const BrowsePharmacyViewer(),
            const SafeArea(child: Gap(60))
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [],
            //   ),
            // )
          ],
        ),
      ),
      // body: ListView(
      //   padding: EdgeInsets.zero,
      //   children: [
      //     const ChooseService(),
      //     // CarouselWidget(
      //     //   height: size.height * .25,
      //     // ),
      //     // const Gap(15),
      //     // RecentBookingPage(
      //     //   onViewAll: () {
      //     //     widget.onPageRequest(2);
      //     //   },
      //     // ),
      //     // const Gap(15),
      //     // SuggestedDriverPage(),
      //     const SafeArea(
      //       top: false,
      //       child: Gap(10),
      //     ),
      //   ],
      // ),
    );
  }
}
