import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/rider_booking/category.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class RestaurantCategory extends StatefulWidget {
  const RestaurantCategory({super.key});

  @override
  State<RestaurantCategory> createState() => _RestaurantCategoryState();
}

class _RestaurantCategoryState extends State<RestaurantCategory>
    with ColorPalette {
  final List<Category> _categories = const [
    Category(
      name: "Burger",
      assetImage: "assets/images/mockup_vectors/Hamburger.png",
      type: 8, // type as category ID
    ),
    Category(
      name: "Fries",
      assetImage: "assets/images/mockup_vectors/Fries.png",
      type: 8, // type as category ID
    ),
    Category(
      name: "Hotdog",
      assetImage: "assets/images/mockup_vectors/Hotdog.png",
      type: 8, // type as category ID
    ),
    Category(
      name: "Coffee",
      assetImage: "assets/images/mockup_vectors/Coffee.png",
      type: 8, // type as category ID
    ),
    Category(
      name: "Taco",
      assetImage: "assets/images/mockup_vectors/Taco.png",
      type: 8, // type as category ID
    ),
    Category(
      name: "Noodles",
      assetImage: "assets/images/mockup_vectors/Noodles.png",
      type: 8, // type as category ID
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Text(
            "Categories",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const Gap(10),
        Consumer(
          builder: (_, ref, child) {
            final bool isDarkMode = ref.watch(darkModeProvider);
            return SizedBox(
              width: double.infinity,
              height: 120,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) => SizedBox(
                  width: 100,
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: isDarkMode
                        ? bgColor.lighten()
                        : purplePalette.withOpacity(.8),
                    elevation: 0,
                    onPressed: () {},
                    child: Stack(
                      children: [
                        Positioned(
                            bottom: 0,
                            right: -20,
                            child: Image.asset(
                              _categories[i].assetImage,
                              width: 100,
                              height: 80,
                            )),
                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              _categories[i].name,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (_, i) => const SizedBox(
                  width: 15,
                ),
                itemCount: _categories.length,
              ),
            );
          },
          // child: ,
        )
      ],
    );
  }
}
