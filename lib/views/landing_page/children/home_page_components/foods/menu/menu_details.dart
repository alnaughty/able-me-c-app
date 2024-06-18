import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/widget/count_controller.dart';
import 'package:able_me/models/store/store_menu.dart';
import 'package:able_me/models/store/store_menu_details.dart';
import 'package:able_me/services/api/menu/menu_api.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/home_page_components/foods/menu/menu_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MenuDetailsPage extends ConsumerStatefulWidget {
  const MenuDetailsPage({
    super.key,
    required this.id,
  });
  final int id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MenuDetailsPageState();
}

class _MenuDetailsPageState extends ConsumerState<MenuDetailsPage>
    with ColorPalette {
  StoreMenuDetails? details;
  final MenuApi _api = MenuApi();
  bool isLoading = false;
  int orderCount = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _api.getDetails(widget.id).then((value) {
        if (value == null) {
          context.pop();
          return;
        }
        setState(() {
          selectedPhoto = value.photoUrl;
          details = value;
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  String? selectedPhoto;
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    final Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: !isLoading,
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              body: details == null
                  ? Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Platform.isIOS
                            ? textColor
                            : textColor.withOpacity(.5),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width,
                                  height: size.height * .4,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: CachedNetworkImage(
                                          imageUrl: selectedPhoto!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                          left: 20,
                                          top: 0,
                                          child: SafeArea(
                                            child: BackButton(
                                              style: ButtonStyle(
                                                  minimumSize: MaterialStateProperty.resolveWith(
                                                      (states) =>
                                                          const Size(60, 60)),
                                                  backgroundColor:
                                                      MaterialStateProperty.resolveWith(
                                                          (states) => purplePalette
                                                              .withOpacity(.8)),
                                                  shape: MaterialStateProperty.resolveWith(
                                                      (states) =>
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(6)))),
                                              color: Colors.white,
                                              onPressed: () {
                                                if (context.canPop()) {
                                                  context.pop();
                                                }
                                              },
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                if (details!.photos.isNotEmpty) ...{
                                  SizedBox(
                                    width: double.infinity,
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: details!.photos.length,
                                      itemBuilder: (_, i) {
                                        final String url = details!.photos[i];
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedPhoto = url;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: url == selectedPhoto
                                                  ? Border.all(
                                                      color: purplePalette,
                                                      width: 3)
                                                  : null,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: url,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                },
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Gap(20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              details!.name.toUpperCase(),
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                          // PassengerController(
                                          //   countCallback: (d) {},
                                          // )
                                          CountController(
                                            onCount: (c) {
                                              setState(() {
                                                orderCount = c;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: isDarkMode
                                                  ? bgColor.lighten()
                                                  : bgColor.darken(),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: orange,
                                                  size: 15,
                                                ),
                                                const Gap(5),
                                                Text(
                                                  details!.ratingCount
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 11,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (details!.isPopular) ...{
                                            const Gap(10),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                // shape: BoxShape.circle,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: purplePalette,
                                              ),
                                              child: const Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .local_fire_department_outlined,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  Gap(2),
                                                  Text(
                                                    "POPULAR",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          },
                                        ],
                                      ),
                                      const Gap(20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Description",
                                            style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            details!.desc,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: textColor.withOpacity(.2),
                                ),
                                const Gap(10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDarkMode
                                              ? bgColor.lighten()
                                              : bgColor.darken(),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: CachedNetworkImage(
                                            imageUrl: details!.store.photoUrl,
                                            width: 55,
                                            height: 55,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              details!.store.name,
                                              style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "${details!.store.state}, ${details!.store.region}, ${details!.store.country}",
                                              style: TextStyle(
                                                color:
                                                    textColor.withOpacity(.5),
                                                height: 1,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.push(
                                              '/restaurant-details/${details!.store.id}');
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty
                                                .resolveWith((states) =>
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5))),
                                            // padding: MaterialStateProperty
                                            //     .resolveWith((states) =>
                                            //         EdgeInsets.all(6)),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith(
                                              (states) => purplePalette,
                                            ),
                                            foregroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Colors.white)),
                                        child: const Text(
                                          "Visit Store",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Gap(10),
                                Divider(
                                  color: textColor.withOpacity(.2),
                                ),
                                if (details!.suggestions.isNotEmpty) ...{
                                  const Gap(20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 0),
                                        child: Text(
                                          "Store Suggestion",
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const Gap(15),
                                      Container(
                                        width: double.infinity,
                                        height: 200,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (_, i) {
                                              final StoreMenu m =
                                                  details!.suggestions[i];
                                              return Container(
                                                width: 230,
                                                height: 200,
                                                color: Colors.blue,
                                                child: MenuCard(menu: m),
                                              );
                                            },
                                            separatorBuilder: (_, i) =>
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                            itemCount:
                                                details!.suggestions.length),
                                      )
                                    ],
                                  ),
                                },
                                const Gap(10),
                              ],
                            ),
                          ),
                        ),
                        SafeArea(
                          top: false,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "\$",
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 14,
                                          height: 1,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const Gap(5),
                                    Text(
                                      (details!.price * orderCount)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 25,
                                          height: 1,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                const Gap(30),
                                Expanded(
                                  child: MaterialButton(
                                    disabledColor: Colors.grey,
                                    onPressed:
                                        details!.isAvailable ? () {} : null,
                                    color: purplePalette,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // padding: const EdgeInsets.symmetric(
                                    //     horizontal: 30),
                                    height: 50,
                                    child: const Center(
                                      child: Text(
                                        "Add to cart",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Gap(20)
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
