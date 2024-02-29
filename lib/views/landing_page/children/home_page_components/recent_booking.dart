import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
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
    final Color textColor = context.theme.secondaryHeaderColor;
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
                    color: context.theme.secondaryHeaderColor),
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
            elevation: 1,
            shadowColor: Colors.grey.shade900,
            color: context.theme.cardColor,
            surfaceTintColor: Colors.transparent,
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
                          color: textColor,
                        ),
                        children: [
                          TextSpan(
                            text: "Transportation",
                            style: TextStyle(
                              color: context.theme.colorScheme.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ]),
                  ),
                  subtitle: Text(
                    "6 Bexley Place,Canberra, 4212, Australia",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor.withOpacity(.6),
                    ),
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
                            .copyWith(color: textColor.withOpacity(.4)),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: textColor.withOpacity(.3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "View Details",
                    style: fontTheme.labelMedium!.copyWith(
                      color: textColor,
                    ),
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
