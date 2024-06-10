import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/book_rider_details.dart';
import 'package:able_me/models/firebase_user_location_model.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/services/api/rider.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/views/landing_page/children/home_page_components/book_driver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShowDriverPage extends ConsumerStatefulWidget {
  const ShowDriverPage({super.key, required this.data});
  final FirebaseUserLocation data;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowDriverPageState();
}

class _ShowDriverPageState extends ConsumerState<ShowDriverPage>
    with ColorPalette {
  static final RiderApi api = RiderApi();
  late final DateTime lastActive = widget.data.lastActive.toDate();
  static const double imageSize = 70;
  static const double imageHeightPercentage = .3;
  BookRiderDetails? details;
  @override
  void initState() {
    fetchDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * imageHeightPercentage,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: (size.height * imageHeightPercentage) -
                            (imageSize / 2),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: AssetImage("assets/images/map2.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Hero(
                          tag: "image-${widget.data.id}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Container(
                              width: imageSize,
                              height: imageSize,
                              padding: const EdgeInsets.all(2),
                              color: widget.data.avatar == "null" ||
                                      widget.data.avatar == ""
                                  ? context.theme.colorScheme.background
                                  : Colors.white,
                              child: widget.data.avatar == "null" ||
                                      widget.data.avatar == ""
                                  ? Center(
                                      child: Text(
                                        widget.data.fullname[0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: context.fontTheme.bodyLarge!
                                                  .fontSize! +
                                              imageSize / 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.data.avatar,
                                      fit: BoxFit.cover,
                                      height: imageSize,
                                      width: imageSize,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Hero(
                      tag: widget.data.fullname,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.data.fullname.capitalizeWords(),
                            style: fontTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor.withOpacity(1),
                            ),
                          ),
                          const Gap(5),
                          Icon(
                            Icons.verified,
                            color: blue,
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: Geocoder.google().findAddressesFromGeoPoint(
                          widget.data.coordinates,
                        ),
                        builder: (_, f) {
                          final List<GeoAddress> currentAddress = f.data ?? [];
                          if (currentAddress.isEmpty) {
                            return Container();
                          }
                          return Text(
                            currentAddress.first.addressLine ?? "",
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        }),
                    Text(
                      "Active ${timeago.format(lastActive)}",
                      style: TextStyle(
                        color: purplePalette,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    if (details != null) ...{
                      const Gap(25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            details!.ratingCount < 1
                                ? "No Ratings Yet"
                                : "Ratings",
                            style: TextStyle(
                              color: textColor.withOpacity(.5),
                            ),
                          ),
                          Row(children: [
                            for (int i = 0; i < 5; i++) ...{
                              Icon(
                                Icons.star,
                                size: 15,
                                color: i < details!.ratingCount
                                    ? Colors.amber
                                    : Colors.grey,
                              )
                            }
                          ]),
                        ],
                      ),
                      const Gap(20),
                      MaterialButton(
                        height: 60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: purplePalette,
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => BookRiderDetailsPage(
                                      data: details!,
                                      lastActive: lastActive,
                                      riderPoint: widget.data.coordinates,
                                    ),
                                fullscreenDialog: true),
                          );
                        },
                        child: const Center(
                          child: Text(
                            "Book Driver",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    } else ...{
                      Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Platform.isIOS
                              ? Colors.white
                              : Colors.white.withOpacity(.5),
                        ),
                      )
                    },
                  ],
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  void fetchDetails() async {
    await api.getDetails(widget.data.id).then((value) {
      setState(() {
        details = value;
      });
      if (value == null) {
        Fluttertoast.showToast(msg: "Unable to fetch rider details.");
        Navigator.of(context).pop();
      }
      return;
    });
  }
}
