import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/widget/store_card.dart';
import 'package:able_me/helpers/widget/store_loading.dart';
import 'package:able_me/models/store/store_model.dart';
import 'package:able_me/models/store/store_params.dart';
import 'package:able_me/view_models/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoreListingDisplay extends ConsumerStatefulWidget {
  const StoreListingDisplay({super.key, this.type = StoreType.restaurant});
  final StoreType type;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoreListingDisplayState();
}

class _StoreListingDisplayState extends ConsumerState<StoreListingDisplay> {
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final storeListing = ref.watch(storeListingProvider(const StoreParams()));
    return storeListing.when(
      data: (_data) {
        final List<StoreModel> data =
            _data.where((element) => element.type == widget.type).toList();
        if (data.isEmpty) {
          /// EMPTY
          return Center(
            child: Text(
              "No restaurant found",
              style: TextStyle(color: textColor),
            ),
          );
        }
        final List<StoreModel> res = data;
        res.sort((a, b) => a.name.compareTo(b.name));
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          itemBuilder: (_, i) {
            final StoreModel _data = res[i];
            return StoreCard(
                data: _data,
                onPressed: () {
                  if (widget.type == StoreType.restaurant) {
                    context.push('/restaurant-details/${_data.id}');
                    return;
                  }
                });
          },
          separatorBuilder: (_, i) => const SizedBox(
            height: 10,
          ),
          itemCount: res.length,
        );
      },
      error: (error, s) => Container(),
      loading: () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        itemBuilder: (_, i) => const StoreDataLoader(),
        separatorBuilder: (_, i) => const SizedBox(
          height: 10,
        ),
        itemCount: 5,
      ),
    );
  }
}
