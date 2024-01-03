import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/date_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class RecentBookingPage extends StatelessWidget with ColorPalette {
  RecentBookingPage({super.key, required this.onViewAll});
  final VoidCallback onViewAll;
  @override
  Widget build(BuildContext context) {
    final TextTheme fontTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            Row(children: [
              const Gap(15),
              Text(
                "Recent Booking",
                style: fontTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
            TextButton(
                onPressed: () {
                  onViewAll();
                },
                child: const Text("View All")),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Card(
            child: InkWell(
              onTap: () {},
              child: Column(children: [
                ListTile(
                  title: Text.rich(
                    TextSpan(
                        text: "John F. Doe - ",
                        style: fontTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Montserrat",
                        ),
                        children: [
                          TextSpan(
                            text: "Transportation",
                            style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ]),
                  ),
                  subtitle: const Text(
                    "6 Bexley Place,Canberra, 4212, Australia",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  subtitleTextStyle: fontTheme.bodySmall,
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 3),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(.5),
                        ),
                      ],
                    ),
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        DateTime.now().subtract(10.days).formatTimeAgo,
                        style: fontTheme.bodySmall!
                            .copyWith(color: Colors.black.withOpacity(.4)),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black.withOpacity(.3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "View Details",
                    style: fontTheme.labelMedium,
                  ),
                ),
                const Gap(5)
              ]),
            ),
          ),
        )
      ],
    );
  }
}
