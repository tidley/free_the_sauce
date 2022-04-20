import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_nft_storage/constants/constants.dart';

dynamic apiKeyProvider = StateProvider((ref) => "");
dynamic filenameProvider = StateProvider((ref) => "Filename...");
dynamic fileProvider = StateProvider((ref) => "");
dynamic cidProvider = StateProvider((ref) => "");
dynamic downloadProvider = StateProvider((ref) => "");
dynamic cacheProvider = StateProvider((ref) => "");

final sauceProvider = StateNotifierProvider<SauceNotifier, List<Sauce>>((ref) {
  return SauceNotifier();
});

final apiKeyProviderAsync = FutureProvider<String>((ref) async {
  return await FileFuns().readFile(apiFileNameConst);
});
