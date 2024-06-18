import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/store/category.dart';
import 'package:able_me/models/store/store_details.dart';
import 'package:able_me/models/store/store_menu.dart';
import 'package:able_me/services/api/store/store_api.dart';
import 'package:able_me/views/landing_page/children/home_page_components/foods/menu/menu_card.dart';
import 'package:able_me/views/landing_page/children/store_map.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RestaurantDetails extends ConsumerStatefulWidget {
  const RestaurantDetails({super.key, required this.id});
  final int id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RestaurantDetailsState();
}

class _RestaurantDetailsState extends ConsumerState<RestaurantDetails>
    with ColorPalette {
  static final StoreAPI _api = StoreAPI();
  StoreDetails? details;
  Future<void> fetch() async {
    final StoreDetails? result = await _api.getDetails(widget.id);
    if (result == null) {
      Fluttertoast.showToast(msg: "Cannot find store");
      context.pop();
      return;
    }
    details = result;
    print(result.menu.length);
    if (mounted) setState(() {});
  }

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetch();
    });
    super.initState();
  }

  final double containerheight = 300;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showPopup() {
    setState(() {
      _showOverlay = true;
    });
  }

  bool _showOverlay = false;
  void _hidePopup() {
    setState(() {
      _showOverlay = false;
    });
  }

  String? itemImgPopup;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            body: details == null
                ? Center(
                    child: SizedBox(
                      height: size.height * .4,
                      child: FullScreenLoader(
                        showText: false,
                        size: size.width * .2,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: containerheight,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: containerheight * .88,
                                  child: CachedNetworkImage(
                                    imageUrl: details!.coverUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 0,
                                child: GestureDetector(
                                  onLongPress: () async {
                                    print("LONG PRESS");
                                    _showPopup();
                                    // await showGeneralDialog(
                                    //   context: context,
                                    //   barrierDismissible: true,
                                    //   barrierLabel: "",
                                    //   barrierColor: Colors.black,
                                    //   transitionBuilder: (context, animation, secondaryAnimation, child) => Container(),
                                    //   pageBuilder: (_, a1, a2) => IgnorePointer(
                                    //     ignoring: true,
                                    //     child: Container(),
                                    //   ),
                                    // );
                                  },
                                  onLongPressEnd: (d) {
                                    print("LONG PRESS END");
                                    _hidePopup();
                                    // Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: containerheight * .45,
                                    height: containerheight * .45,
                                    // color: Colors.green,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: bgColor, width: 3),
                                        boxShadow: [
                                          BoxShadow(
                                              color: textColor.withOpacity(.3),
                                              offset: const Offset(-1, 1),
                                              blurRadius: 5)
                                        ]),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          containerheight * .45),
                                      child: CachedNetworkImage(
                                        imageUrl: details!.photoUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: 20,
                                  top: 0,
                                  child: SafeArea(
                                    child: BackButton(
                                      style: ButtonStyle(
                                          minimumSize:
                                              MaterialStateProperty.resolveWith(
                                                  (states) =>
                                                      const Size(60, 60)),
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => purplePalette
                                                      .withOpacity(.8)),
                                          shape: MaterialStateProperty.resolveWith(
                                              (states) => RoundedRectangleBorder(
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
                        const Gap(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                details!.name.capitalizeWords(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                details!.desc,
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                              const Gap(20),

                              /// MAPA
                              LayoutBuilder(
                                builder: (_, c) => SizedBox(
                                  width: c.maxWidth,
                                  height: 170,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: StoreMapPage(
                                        coordinates: details!.coordinates),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              child: Text(
                                "categories".capitalizeWords(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, i) {
                                    final Category cat = details!.categories[i];
                                    // RawChip(label: label)
                                    return RawChip(
                                        onPressed: () {},
                                        // padding: const EdgeInsets.symmetric(
                                        //     horizontal: 25, vertical: 15),
                                        labelPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        backgroundColor: bgColor.darken(),
                                        // color: MaterialStateProperty.resolveWith(
                                        //     (s) => bgColor.lighten()),
                                        label: Text(
                                          cat.name.capitalizeWords(),
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 10,
                                          ),
                                        ));
                                  },
                                  separatorBuilder: (_, i) => const SizedBox(
                                        width: 10,
                                      ),
                                  itemCount: details!.categories.length),
                            ),
                          ],
                        ),
                        const Gap(20),
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            childAspectRatio: .8,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (_, i) {
                            final StoreMenu menu = details!.menu[i];
                            return GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  itemImgPopup = menu.photoUrl;
                                });
                              },
                              onLongPressEnd: (d) {
                                setState(() {
                                  itemImgPopup = null;
                                });
                              },
                              child: MenuCard(menu: menu),
                            );
                          },
                          itemCount: details!.menu.length,
                          // crossAxisCount: 2,

                          // children: details!.menu
                          //     .map((e) => GridTile(
                          //           child: Container(
                          //             // width: 100,
                          //             // height: 100,
                          //             color: Colors.red,
                          //           ),
                          //         ))
                          //     .toList(),
                        ),
                        const SafeArea(
                          top: false,
                          child: SizedBox(
                            height: 10,
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.center,
          child: AnimatedContainer(
            duration: 400.ms,
            width: _showOverlay ? size.width : 0,
            height: _showOverlay ? size.height : 0,
            color: Colors.transparent,
            child: _showOverlay
                ? Center(
                    child: CachedNetworkImage(
                      imageUrl: details!.photoUrl,
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.center,
          child: AnimatedContainer(
            duration: 400.ms,
            width: itemImgPopup != null ? size.width : 0,
            height: itemImgPopup != null ? size.height : 0,
            color: Colors.black.withOpacity(.5),
            child: itemImgPopup == null
                ? Container()
                : Center(
                    child: CachedNetworkImage(
                      imageUrl: itemImgPopup!,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ),
        // AnimatedPositioned(
        //   top: 0,
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: _showOverlay
        //       ? Container(
        // width: size.width, height: size.height, color: Colors.red)
        //       : Container(
        // width: 0,
        // height: 0,
        //         ),
        //   duration: 800.ms,
        // )
      ],
    );
  }
}
