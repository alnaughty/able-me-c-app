import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/store/store_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class StoreCard extends StatelessWidget with ColorPalette {
  StoreCard({super.key, required this.data, required this.onPressed});
  final StoreModel data;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return GestureDetector(
      onTap: onPressed,
      // onTap: () {
      //   // context.push('/restaurant-details/${data.id}');
      // },
      child: Card(
        shadowColor: bgColor,
        color: bgColor.lighten(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: data.coverUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: CachedNetworkImage(
                        imageUrl: data.photoUrl,
                        width: double.infinity,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name.capitalizeWords(),
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          data.desc.capitalizeWords(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(1),
                          ),
                        ),
                        Text(
                          "${data.state},${data.region},${data.country}"
                              .capitalizeWords(),
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 10,
                            // fontStyle: FontStyle.italic,
                            color: textColor.withOpacity(.5),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Text(
                        data.ratingCount.toString(),
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const Gap(2),
                      Icon(
                        Icons.star,
                        color: orange,
                        size: 15,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
