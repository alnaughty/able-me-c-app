import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/book_rider_widget_helpers/pricing.dart';
import 'package:able_me/models/book_rider_details.dart';
import 'package:able_me/models/rider_booking/rider_booking_payloads.dart';
import 'package:able_me/views/landing_page/children/home_page_components/driver_and_user_map.dart';
import 'package:able_me/views/landing_page/children/home_page_components/eta_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookRiderDetailsPage extends ConsumerStatefulWidget {
  const BookRiderDetailsPage(
      {super.key,
      required this.data,
      required this.lastActive,
      required this.riderPoint});
  final BookRiderDetails data;
  final DateTime lastActive;
  final GeoPoint riderPoint;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookRiderPageState();
}

class _BookRiderPageState extends ConsumerState<BookRiderDetailsPage>
    with ColorPalette {
  late final DriverAndUserMap map = DriverAndUserMap(
    riderPoint: widget.riderPoint,
  );
  RiderBookingPayloads? payload;
  static const double imageSize = 60;
  static const double imageHeightPercentage = .3;
  @override
  Widget build(BuildContext context) {
    final TextTheme fontTheme = Theme.of(context).textTheme;
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Book Driver"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: "image-${widget.data.id}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Container(
                              width: imageSize,
                              height: imageSize,
                              padding: const EdgeInsets.all(2),
                              color: widget.data.avatar == null ||
                                      widget.data.avatar == "null" ||
                                      widget.data.avatar == ""
                                  ? context.theme.colorScheme.background
                                  : Colors.white,
                              child: widget.data.avatar == null ||
                                      widget.data.avatar == "null" ||
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
                                      imageUrl: widget.data.avatar!,
                                      fit: BoxFit.cover,
                                      height: imageSize,
                                      width: imageSize,
                                    ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.fullname.capitalizeWords(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                widget.data.email,
                                style: TextStyle(
                                  color: textColor.withOpacity(.5),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "Active ${timeago.format(widget.lastActive)}",
                                style: TextStyle(
                                  color: purplePalette,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    const Gap(20),
                    map,
                    const Gap(30),
                    // ETAWidget(riderPoint: widget.riderPoint)
                    RiderTextControllers(
                      onFinishCallback: (RiderBookingPayloads data) {},
                    ),
                  ],
                ),
              ),
            ),
            const Gap(25),
          ],
        ),
      ),
    );
  }
}
