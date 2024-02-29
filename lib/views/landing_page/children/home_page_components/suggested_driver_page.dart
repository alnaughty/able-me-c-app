import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/view_models/app/coordinate.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class SuggestedDriverPage extends StatelessWidget with ColorPalette {
  SuggestedDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme fontTheme = Theme.of(context).textTheme;
    final Color textColor = context.theme.secondaryHeaderColor;
    // final currentuUser = ref.
    return Consumer(
      builder: (context, ref, child) {
        final UserModel? user = ref.watch(currentUser);
        final Position? userLoc = ref.watch(coordinateProvider);
        if (user == null) return Container();
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
                if (userLoc != null) ...{
                  TextButton(
                    onPressed: () {
                      context
                          .push('/map-page/${user.id}/${userLoc.toString()}');
                    },
                    child: const Text(
                      "View All",
                    ),
                  ),
                }
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) => Card(
                        elevation: 1,
                        shadowColor: Colors.grey.shade900,
                        color: context.theme.cardColor,
                        surfaceTintColor: Colors.transparent,
                        child: ListTile(
                          onTap: () {},
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          subtitle: const Text(
                            "6 Bexley Place,Canberra, 4212, Australia",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitleTextStyle: fontTheme.bodySmall!.copyWith(
                            color: textColor.withOpacity(.5),
                          ),
                          title: const Text("John F. Doe"),
                          titleTextStyle: fontTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: textColor.withOpacity(1),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: textColor,
                          ),
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
                        ),
                      ),
                  separatorBuilder: (_, i) => const Gap(5),
                  itemCount: 4),
              // child: Column(
              //   children: List.generate(5, (index) => Li),
              // ),
            ),
          ],
        );
      },
      // child: ,
    );
  }
}
