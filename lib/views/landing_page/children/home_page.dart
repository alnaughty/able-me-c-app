import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/services/geolocation_service.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/views/landing_page/children/home_page_components/recent_booking.dart';
import 'package:able_me/views/landing_page/children/home_page_components/suggested_driver_page.dart';
import 'package:able_me/views/widget_components/badged_icon.dart';
import 'package:able_me/views/widget_components/carousel_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserModel? _udata = ref.watch(currentUser.notifier).state;
    final Position? pos = ref.watch(coordinateProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 70,
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _udata?.fullname ?? "",
              style: TextStyle(
                fontSize: 16,
                color: context.theme.secondaryHeaderColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            if (pos != null) ...{
              FutureBuilder(
                  future: Geocoder.google().findAddressesFromCoordinates(
                    Coordinates(pos.latitude, pos.longitude),
                  ),
                  builder: (_, f) {
                    final List<GeoAddress> currentAddress = f.data ?? [];
                    if (currentAddress.isEmpty) return Container();
                    return Text(
                      currentAddress.first.addressLine ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.secondaryHeaderColor,
                        fontWeight: FontWeight.w300,
                      ),
                    );
                  })
            }
            // if (currentAddress.isNotEmpty) ...{

            // },
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
                                  _udata.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        context.fontTheme.bodyLarge!.fontSize! +
                                            5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : CachedNetworkImage(imageUrl: _udata.avatar!),
                      ),
              ),
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
