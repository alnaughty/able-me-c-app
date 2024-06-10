import 'dart:io';

import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:able_me/models/rider_booking/user_booking_classes/user_booking_transpo.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/notifiers/my_booking_history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/geocoder_services/geocoder.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Consumer(builder: (_, ref, c) {
      final UserModel? _udata = ref.watch(currentUser.notifier).state;
      final bookingData = ref.watch(userBookingHistory);
      return Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              leading: Center(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 10, top: 5, bottom: 5),
                child: CustomImageBuilder(
                  avatar: _udata!.avatar,
                  placeHolderName: _udata.name[0],
                  size: 45,
                ),
              )),
              title: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Hi! ${_udata.name.capitalizeWords()}",
                ),
                titleTextStyle: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontFamily: "Montserrat",
                ),
                subtitle: const Text("Check your history"),
                subtitleTextStyle: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontFamily: "Montserrat",
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_list,
                      color: textColor,
                    ))
              ],
            ),
          ),
          // Expanded(
          //     child: Container(
          //   color: Colors.red,
          // ))
          Expanded(
            child: bookingData.when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      "No data found",
                      style: TextStyle(color: textColor),
                    ),
                  );
                }
                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  itemBuilder: (BuildContext context, int index) {
                    final UserTransportationBooking val = data[index];
                    return Card(
                      color: bgColor.lighten(),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // if (val.type == 5)...{
                                //   //Scheduled

                                // }else if(val.type ==),
                              ],
                            ),
                            FutureBuilder(
                                future:
                                    Geocoder.google().findAddressesFromGeoPoint(
                                  val.destination,
                                ),
                                builder: (_, f) {
                                  final List<GeoAddress> currentAddress =
                                      f.data ?? [];
                                  if (currentAddress.isEmpty) {
                                    return Container();
                                  }
                                  return Text(
                                    currentAddress.first.addressLine ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }),
                            Text(
                              val.status == 0 ? "Pending" : "Completed",
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 15,
                  ),
                  itemCount: data.length,
                );
              },
              error: (error, s) => Center(
                child: Text(
                  "An error occurred while processing your request : $error",
                  style: TextStyle(color: textColor),
                ),
              ),
              loading: () => Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  backgroundColor:
                      Platform.isIOS ? textColor : textColor.withOpacity(.5),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
