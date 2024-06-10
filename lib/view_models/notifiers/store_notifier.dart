import 'package:able_me/models/store/store_model.dart';
import 'package:able_me/models/store/store_params.dart';
import 'package:able_me/services/api/store/store_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final storeApiProvider = Provider<StoreAPI>((ref) => StoreAPI());

final storeListingProvider =
    FutureProvider.family<List<StoreModel>, StoreParams>((ref, params) async {
  return ref.watch(storeApiProvider).getStore(params: params);
});
