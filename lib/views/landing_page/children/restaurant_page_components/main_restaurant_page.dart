import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/store/store_model.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/restaurant_page_components/components/listing.dart';
import 'package:able_me/views/landing_page/children/restaurant_page_components/restaurant_category.dart';
import 'package:able_me/views/widget_components/carousel_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MainRestaurantPage extends ConsumerStatefulWidget {
  const MainRestaurantPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainRestaurantPageState();
}

class _MainRestaurantPageState extends ConsumerState<MainRestaurantPage>
    with ColorPalette {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    setState(() {
      if (_scrollController.offset <= 200) {
        titleColor = !isDarkMode ? bgColor : Colors.white;
      } else {
        titleColor = textColor;
      }
    });
  }

  late Color titleColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    final UserModel? _udata = ref.watch(currentUser.notifier).state;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;

    final CurrentAddress? address = ref.watch(currentAddressNotifier);
    // print(address == null);
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          // backgroundColor: Colors.transparent,
          centerTitle: true,
          leadingWidth: 80,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned.fill(
                  child: CarouselWidget(
                      fromAsset: true,
                      images: List.generate(3,
                          (int index) => "assets/images/food${index + 1}.jpg")),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(.3),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Able Me Food Service",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Find the best food & Restaurant you like"
                            .capitalizeWords(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          expandedHeight: 300,
          leading: _udata != null
              ? Center(
                  child: GestureDetector(
                    onTap: () => context.push('/profile-page'),
                    child: CustomImageBuilder(
                      avatar: _udata.avatar,
                      placeHolderName: _udata.name[0].toUpperCase(),
                    ),
                  ),
                )
              : null,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.search,
                  color: titleColor,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.shopping_basket_outlined,
                  color: titleColor,
                )),
            // if (address != null) ...{
            //   Container(
            //     width: 20,
            //   )
            // },
          ],
          title: address == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/location.svg",
                      color: titleColor,
                      width: 20,
                    ),
                    const Gap(5),
                    Text(
                      "${address.locality}, ${address.city}, ${address.countryCode}"
                          .capitalizeWords(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: titleColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
        SliverList.list(
          children: const [
            Gap(10),
            RestaurantCategory(),
            Gap(20),
            StoreListingDisplay(
              type: StoreType.restaurant,
            ),
            SafeArea(
                child: SizedBox(
              height: 20,
            ))
          ],
        )
      ],
    );
  }
}
