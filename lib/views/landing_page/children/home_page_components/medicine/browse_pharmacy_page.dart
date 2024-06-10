import 'dart:io';

import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/store/store_model.dart';
import 'package:able_me/models/store/store_params.dart';
import 'package:able_me/services/api/store/store_api.dart';
import 'package:able_me/view_models/notifiers/store_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowsePharmacyPage extends ConsumerStatefulWidget {
  const BrowsePharmacyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BrowsePharmacyPageState();
}

class _BrowsePharmacyPageState extends ConsumerState<BrowsePharmacyPage> {
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
      type: 2,
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
          title: const Text("Browse Pharmacy"),
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
                  filled: true,
                  fillColor: textColor.withOpacity(.1),
                  prefixIcon: Icon(
                    Icons.search,
                    color: textColor,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      if (_search.text.isEmpty) return;
                      _search.clear();
                      ref.read(storeListingProvider(
                          const StoreParams(keyword: null, type: 1, page: 1)));
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
                            "No pharmacy found",
                            style: TextStyle(color: textColor),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          itemBuilder: (_, i) {
                            final StoreModel datum = _displayData[i];
                            return Card(
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          datum.name.capitalizeWords(),
                                          style: TextStyle(
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          datum.desc.capitalizeWords(),
                                          style: TextStyle(
                                            color: textColor.withOpacity(.5),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (_, i) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: _displayData.length),
              // child: _storeListing.when(
              //   data: (data) {
              //     if (data.isEmpty) {
              // return Center(
              //   child: Text(
              //     "No restaurant found",
              //     style: TextStyle(color: textColor),
              //   ),
              // );
              //     }
              // return ListView.separated(
              //     padding: const EdgeInsets.symmetric(
              //         horizontal: 20, vertical: 15),
              //     itemBuilder: (_, i) {
              //       final StoreModel datum = data[i];
              //       return Card(
              //         shadowColor: bgColor,
              //         color: bgColor.lighten(),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             ClipRRect(
              //               borderRadius: const BorderRadius.vertical(
              //                   top: Radius.circular(10)),
              //               child: CachedNetworkImage(
              //                 imageUrl: datum.coverUrl,
              //                 width: double.infinity,
              //                 height: 150,
              //                 fit: BoxFit.fitWidth,
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 15,
              //                 vertical: 20,
              //               ),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     datum.name.capitalizeWords(),
              //                     style: TextStyle(
              //                       color: textColor,
              //                     ),
              //                   ),
              //                   Text(
              //                     datum.desc.capitalizeWords(),
              //                     style: TextStyle(
              //                       color: textColor.withOpacity(.5),
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //       );
              //     },
              //     separatorBuilder: (_, i) => const SizedBox(
              //           height: 10,
              //         ),
              //     itemCount: data.length);
              //   },
              //   error: (err, s) => Center(
              //     child: Text(
              //       "An error occurred while processing your request : $err $s",
              //       style: TextStyle(color: textColor),
              //     ),
              //   ),
              // loading: () => Center(
              //   child: CircularProgressIndicator.adaptive(
              //     valueColor: const AlwaysStoppedAnimation(Colors.white),
              //     backgroundColor:
              //         Platform.isIOS ? textColor : textColor.withOpacity(.5),
              //   ),
              // ),
              // ),
            )
          ],
        ),
        // body: ListView(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //   children: [

        //   ],
        // ),
      ),
    );
  }
}
