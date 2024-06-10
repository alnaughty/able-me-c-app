import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/store/store_model.dart';
import 'package:able_me/models/store/store_params.dart';
import 'package:able_me/services/api/store/store_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BrowseRestaurantPage extends ConsumerStatefulWidget {
  const BrowseRestaurantPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BrowseRestaurantPageState();
}

class _BrowseRestaurantPageState extends ConsumerState<BrowseRestaurantPage>
    with ColorPalette {
  late final TextEditingController _search;
  static final StoreAPI _api = StoreAPI();
  List<StoreModel> _displayData = [];
  bool isLoading = true;
  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });
    _displayData = await _api.getStore(
        params: StoreParams(
      type: 1,
      keyword: _keyword,
    ));
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _search = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetch();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    // TODO: implement dispose
    super.dispose();
    // ref.read(storeListing(const StoreParams(keyword: null, type: 1, page: 1)));
  }

  // void _fetchRestaurants(String? keyword) {
  //   print("REFRESH : $keyword");
  //   setState(() {});
  //   // ref.refresh(storeListing(StoreParams()));
  //   _storeListing = ref.refresh(
  //       storeListing(StoreParams(keyword: _search.text, type: 1, page: 1)));
  //   // ref.refresh(
  //   //     storeListing(StoreParams(keyword: _search.text, type: 1, page: 1)));
  // }
  String _keyword = "";
  // late AsyncValue<List<StoreModel>> _storeListing =
  //     ref.watch(storeListing(const StoreParams(
  //   type: 1,
  // )));
  @override
  Widget build(BuildContext context) {
    // final _storeListing =
    //     ref.read(storeListing(StoreParams(keyword: _keyword, type: 1)));
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Browse Restaurant"),
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                ),
                controller: _search,
                keyboardType: TextInputType.text,
                onSubmitted: (t) async {
                  if (t.isEmpty) return;
                  _keyword = t;
                  // final StoreParams params = StoreParams(type: 1, keyword: t);
                  // ref.refresh(storeListing(params));
                  // ref.watch(storeListing(params));
                  // ref.invalidate(storeListing);
                  // _storeListing =
                  //     ref.watch(storeListing(StoreParams(type: 1, keyword: t)));
                  // _storeListing = ref
                  //     .refresh(storeListing(StoreParams(type: 1, keyword: t)));
                  if (mounted) setState(() {});
                  await fetch();
                  // storeListing.overrideWithProvider(
                  //     FutureProvider.family<List<StoreModel>, StoreParams>(
                  //         (ref, params) {
                  //   return ref
                  //       .watch(storeApiProvider)
                  //       .getStore(keyword: t, type: 1, page: params.page);
                  // }));
                  // // _fetchRestaurants(t);
                  // setState(() {
                  //   keyword = t;
                  // });
                  // _search.clear();
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  isDense: true,
                  filled: true,
                  fillColor: textColor.withOpacity(.1),
                  prefixIcon: Icon(
                    Icons.search,
                    color: textColor,
                  ),
                  suffixIcon: InkWell(
                    onTap: () async {
                      if (_search.text.isEmpty) return;
                      _search.clear();
                      _keyword = "";
                      setState(() {});
                      await fetch();
                      // ref.read(storeListing(
                      //     const StoreParams(keyword: null, type: 1, page: 1)));
                    },
                    child: Icon(
                      Icons.clear,
                      color: textColor,
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(.3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Platform.isIOS
                            ? textColor
                            : textColor.withOpacity(.5),
                      ),
                    )
                  : _displayData.isEmpty
                      ? Center(
                          child: Text(
                            "No restaurant found",
                            style: TextStyle(color: textColor),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          itemBuilder: (_, i) {
                            final StoreModel datum = _displayData[i];
                            return GestureDetector(
                              onTap: () {
                                context.push('/restaurant-details/${datum.id}');
                              },
                              child: Card(
                                shadowColor: bgColor,
                                color: bgColor.lighten(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl: datum.coverUrl,
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
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            child: SizedBox(
                                              height: 60,
                                              width: 60,
                                              child: CachedNetworkImage(
                                                imageUrl: datum.photoUrl,
                                                width: double.infinity,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const Gap(10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  datum.name.capitalizeWords(),
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  datum.desc.capitalizeWords(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: textColor
                                                        .withOpacity(1),
                                                  ),
                                                ),
                                                Text(
                                                  "${datum.state},${datum.region},${datum.country}"
                                                      .capitalizeWords(),
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    // fontStyle: FontStyle.italic,
                                                    color: textColor
                                                        .withOpacity(.5),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Gap(10),
                                          Row(
                                            children: [
                                              Text(
                                                datum.ratingCount.toString(),
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
                          },
                          separatorBuilder: (_, i) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: _displayData.length,
                        ),
            )
          ],
        ),
      ),
    );
  }
}
