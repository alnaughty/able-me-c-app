import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/widget/book_rider_widget_helpers/map_picker.dart';
import 'package:able_me/models/profile/user_address.dart';
import 'package:able_me/services/api/user/address_api.dart';
import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:able_me/views/landing_page/children/profile_page_components/add_address_modal.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

final addressFutureProvider = FutureProvider<List<UserAddress>>((ref) => []);

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({super.key});

  @override
  ConsumerState<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> with ColorPalette {
  final AddressApi _api = AddressApi();
  CurrentAddress? toAdd;
  void refresh() async {
    ref.invalidate(addressFutureProvider);
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(addressFutureProvider);
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return PopScope(
      canPop: !_isLoading,
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Addresses"),
                centerTitle: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              body: data.when(
                data: (data) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push<GeoPoint>(
                            MaterialPageRoute(
                              builder: (_) => AbleMeMapPicker(
                                geoPointCallback: (g) async {
                                  await showModalBottomSheet(
                                    context: context,
                                    builder: (_) => AddAddressModal(
                                      coordinate: g,
                                      onCallback: (s) async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await _api
                                            .add(
                                                address: s.address.addressLine,
                                                locality: s.address.locality,
                                                city: s.address.city,
                                                country: s.address.countryCode,
                                                coordinates:
                                                    s.address.coordinates,
                                                title: s.val)
                                            .then((v) {
                                          if (v != null) {
                                            refresh();
                                          }
                                        });
                                        _isLoading = false;
                                        if (mounted) setState(() {});

                                        // setState(() {
                                        //   _isLoading = s;
                                        // });
                                      },
                                    ),
                                  );
                                  // ref.watch(bookDataProvider.notifier).update(
                                  //     (state) => state.copyWith(
                                  //         payload: state.payload
                                  //             .copyWith(pickupLocation: g)));
                                  // _vm.updatePickupLocation(g);
                                  // await Geocoder.google()
                                  //     .findAddressesFromGeoPoint(g)
                                  //     .then((value) {
                                  //   if (value.isNotEmpty) {
                                  //     _pickup.text =
                                  //         value.first.addressLine ?? "Unknown Address";
                                  //     if (mounted) setState(() {});
                                  //   }
                                  // });
                                  // widget.onPickupcallback(g);
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: context.csize!.width,
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: purplePalette.withOpacity(.3),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: purplePalette,
                              ),
                              const Gap(20),
                              Text(
                                "Add New Address",
                                style: TextStyle(
                                    color: purplePalette,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, i) {
                          final UserAddress address = data[i];
                          return Container();
                        },
                        separatorBuilder: (_, i) => const SizedBox(
                          height: 20,
                        ),
                        itemCount: data.length,
                      ),
                      if (toAdd != null) ...{},
                    ],
                  );
                },
                error: (err, s) => Container(),
                loading: () => const Center(
                  child: FullScreenLoader(),
                ),
              ),
            ),
          ),
          if (_isLoading) ...{
            Container(
              width: context.csize!.width,
              height: context.csize!.height,
              color: Colors.black.withOpacity(.5),
              child: const Center(
                child: FullScreenLoader(
                  showText: false,
                ),
              ),
            )
          },
        ],
      ),
    );
  }
}
