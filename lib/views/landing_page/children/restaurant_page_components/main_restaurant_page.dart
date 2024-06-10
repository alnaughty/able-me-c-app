import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/store/store_model.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/restaurant_page_components/components/listing.dart';
import 'package:able_me/views/landing_page/children/restaurant_page_components/restaurant_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

class MainRestaurantPage extends ConsumerStatefulWidget {
  const MainRestaurantPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainRestaurantPageState();
}

class _MainRestaurantPageState extends ConsumerState<MainRestaurantPage>
    with ColorPalette {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Position? pos = ref.watch(coordinateProvider);
    final UserModel? _udata = ref.watch(currentUser.notifier).state;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(65),
            child: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                // leading: _udata != null
                //     ? Container(
                //         width: 70,
                //       )
                //     : null,
                leadingWidth: 80,
                leading: _udata != null
                    ? Center(
                        child: CustomImageBuilder(
                          avatar: _udata.avatar,
                          placeHolderName: _udata.name[0].toUpperCase(),
                        ),
                      )
                    : null,
                // if (_udata != null) ...{
                // CustomImageBuilder(
                //   avatar: _udata.avatar,
                //   placeHolderName: _udata.name[0].toUpperCase(),
                // ),
                //   const Gap(10)
                // },
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shopping_basket_outlined,
                        color: textColor,
                      )),
                  if (_udata != null) ...{
                    Container(
                      width: 20,
                    )
                  },
                ],
                title: pos == null
                    ? Text(
                        "Checking Location",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      )
                    : FutureBuilder(
                        future: Geocoder.google().findAddressesFromCoordinates(
                          Coordinates(pos.latitude, pos.longitude),
                        ),
                        builder: (_, f) {
                          final List<GeoAddress> currentAddress = f.data ?? [];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/location.svg",
                                color: textColor,
                                width: 20,
                              ),
                              const Gap(5),
                              if (currentAddress.isEmpty) ...{
                                Text(
                                  "Unknown Location",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: textColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                )
                              } else ...{
                                Text(
                                  "${currentAddress.first.locality}, ${currentAddress.first.countryCode}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: textColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              },
                            ],
                          );
                        })),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text: "Find Your ",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: textColor,
                        fontSize: 25,
                      ),
                      children: [
                        TextSpan(
                          text: "Best Food",
                          style: TextStyle(
                            color: isDarkMode ? textColor : purplePalette,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const TextSpan(
                          text: " Or ",
                        ),
                        TextSpan(
                          text: "Restaurant",
                          style: TextStyle(
                            color: isDarkMode ? textColor : purplePalette,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const TextSpan(
                          text: " Around You",
                        ),
                      ]),
                ),
              ],
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onTap: () {
                print("TAP");
              },
              readOnly: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: textColor.withOpacity(.5),
                    )),
                enabled: true,
                filled: true,
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(.5),
                  fontSize: 14,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                // prefixIconConstraints: const BoxConstraints(
                //   minWidth: 60,
                //   minHeight: 50,
                // ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.withOpacity(.5),
                  size: 20,
                ),
                fillColor: Colors.grey.withOpacity(.2),
              ),
            ),
          ),
          const Gap(20),
          const RestaurantCategory(),
          const Gap(20),
          const StoreListingDisplay(
            type: StoreType.pharmacy,
          ),
          const SafeArea(
              child: SizedBox(
            height: 20,
          ))
        ],
      ),
    );
  }
}
