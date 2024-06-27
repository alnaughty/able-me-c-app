import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/store/store_menu.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MenuCard extends ConsumerStatefulWidget {
  const MenuCard({super.key, required this.menu, this.showTitle = true});
  final StoreMenu menu;
  final bool showTitle;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuCardState();
}

class _MenuCardState extends ConsumerState<MenuCard> with ColorPalette {
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return LayoutBuilder(builder: (context, c) {
      return GestureDetector(
        onTap: () {
          context.push('/menu-details/${widget.menu.id}');
        },
        child: Container(
          width: c.maxWidth,
          color: isDarkMode ? bgColor.lighten() : bgColor.darken(),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    SizedBox(
                      width: c.maxWidth,
                      height: !widget.showTitle ? c.maxHeight : c.maxWidth * .9,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: widget.menu.photoUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (widget.menu.isPopular) ...{
                            Positioned(
                              top: 10,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(20)),
                                  color: purplePalette,
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.local_fire_department_outlined,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Gap(2),
                                    Text(
                                      "Popular",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          }
                        ],
                      ),
                    ),
                    if (widget.showTitle) ...{
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: Center(
                            child: Text(
                              widget.menu.name.toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      )
                    },
                  ],
                ),
              ),
              if (!widget.menu.isAvailable) ...{
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(.3),
                    child: const Center(
                      child: Text(
                        "OUT OF STOCK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                )
              },
            ],
          ),
        ),
      );
    });
  }
}
