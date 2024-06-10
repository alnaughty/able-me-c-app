import 'dart:math';

import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class StoreDataLoader extends StatelessWidget {
  const StoreDataLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final Color bgColor = context.theme.scaffoldBackgroundColor;
        final Color textColor = context.theme.secondaryHeaderColor;
        final bool isDarkMode = ref.watch(darkModeProvider);
        return LayoutBuilder(builder: (context, c) {
          return Shimmer.fromColors(
            baseColor: bgColor.lighten(),
            highlightColor: Colors.grey.shade400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: bgColor.lighten().withOpacity(.5),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                ),
                const Gap(10),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: bgColor.lighten().withOpacity(.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Gap(5),
                Container(
                  width: double.parse(
                      (Random().nextInt((c.maxWidth - 160).toInt()) + 160)
                          .toString()),
                  height: (Random().nextDouble() * 30) + 20,
                  decoration: BoxDecoration(
                    color: bgColor.lighten().withOpacity(.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // ClipRRect(
                // borderRadius: const BorderRadius.vertical(
                //     top: Radius.circular(10)),
                //                         child: CachedNetworkImage(
                //                           imageUrl: datum.coverUrl,
                //                           width: double.infinity,
                //                           height: 150,
                //                           fit: BoxFit.fitWidth,
                //                         ),
                //                       ),
              ],
            ),
          );
        });
      },
    );
  }
}
