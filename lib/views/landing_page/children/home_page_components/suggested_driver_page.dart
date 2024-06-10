import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/firebase_user_location_model.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/firebase/user_location_service.dart';
import 'package:able_me/services/geocoder_services/geocoder.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/notifiers/user_location_state_notifier.dart';
import 'package:able_me/views/landing_page/children/home_page_components/show_driver_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class SuggestedDriverPage extends StatefulWidget with ColorPalette {
  SuggestedDriverPage({super.key});

  @override
  State<SuggestedDriverPage> createState() => _SuggestedDriverPageState();
}

class _SuggestedDriverPageState extends State<SuggestedDriverPage> {
  @override
  void initState() {
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
    final TextTheme fontTheme = Theme.of(context).textTheme;
    final Color textColor = context.theme.secondaryHeaderColor;
    // final currentuUser = ref.

    return Consumer(
      builder: (context, ref, child) {
        final UserModel? user = ref.watch(currentUser);
        final Position? userLoc = ref.watch(coordinateProvider.notifier).state;
        if (user == null) return Container();
        if (userLoc == null) return Container();
        final List<FirebaseUserLocation> data = ref.watch(userLocationProvider);
        if (data.isEmpty) return Container();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                Row(children: [
                  const Gap(15),
                  Text(
                    "Driver(s) Near You",
                    style: fontTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700, color: textColor),
                  ),
                ]),
                TextButton(
                  onPressed: () {
                    context.push('/map-page');
                  },
                  child: const Text(
                    "View All",
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    final FirebaseUserLocation datum = data[i];
                    return Card(
                      elevation: 1,
                      shadowColor: Colors.grey.shade900,
                      color: context.theme.cardColor,
                      surfaceTintColor: Colors.transparent,
                      child: ListTile(
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            constraints: BoxConstraints(
                              maxHeight: context.csize!.height,
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => ShowDriverPage(
                              data: datum,
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        // subtitle: const Text(
                        //   "6 Bexley Place,Canberra, 4212, Australia",
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        subtitle: FutureBuilder(
                            future: Geocoder.google().findAddressesFromGeoPoint(
                              datum.coordinates,
                            ),
                            builder: (_, f) {
                              final List<GeoAddress> currentAddress =
                                  f.data ?? [];
                              if (currentAddress.isEmpty) {
                                return Container();
                              }
                              return Text(
                                // "${datum.coordinates.latitude}, ${datum.coordinates.longitude}",
                                "${currentAddress.first.addressLine}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.secondaryHeaderColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              );
                            }),
                        subtitleTextStyle: fontTheme.bodySmall!.copyWith(
                          color: textColor.withOpacity(.5),
                        ),
                        title: Text(datum.fullname.capitalizeWords()),
                        titleTextStyle: fontTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textColor.withOpacity(1),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: textColor,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Container(
                              width: 55,
                              height: 55,
                              padding: const EdgeInsets.all(2),
                              color:
                                  datum.avatar == "null" || datum.avatar == ""
                                      ? context.theme.colorScheme.background
                                      : Colors.white,
                              child:
                                  datum.avatar == "null" || datum.avatar == ""
                                      ? Center(
                                          child: Text(
                                            datum.fullname[0].toUpperCase(),
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
                                          imageUrl: datum.avatar,
                                          fit: BoxFit.cover,
                                          height: 55,
                                          width: 55,
                                        )

                              // decoration: BoxDecoration(
                              //   color: Colors.grey.shade100,
                              //   shape: BoxShape.circle,
                              //   boxShadow: [
                              //     BoxShadow(
                              //       offset: const Offset(0, 3),
                              //       blurRadius: 5,
                              //       color: Colors.black.withOpacity(.5),
                              //     ),
                              //   ],
                              // ),
                              ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, i) => const Gap(5),
                  itemCount: data.length),
              // child: Column(
              //   children: List.generate(5, (index) => Li),
              // ),
            ),
          ],
        );
        // return StreamBuilder<>(
        //     stream: ,
        //     builder: (context, snapshot) {
        //       if (snapshot.hasError || !snapshot.hasData) {
        //         return Container();
        //       }
        //       final List<FirebaseUserLocation> data = snapshot.data ?? [];
        //       if (data.isEmpty) {
        //         return Container();
        //       }

        //     });
      },
      // child: ,
    );
  }
}
