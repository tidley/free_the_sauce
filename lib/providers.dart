import 'dart:io';

import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_nft_storage/constants/constants.dart';

//////////////////////////////////////////////////////////////////
////////////////////////// NEW PROVIDERS /////////////////////////
//////////////////////////////////////////////////////////////////
dynamic fileNameListProvider =
    StateNotifierProvider<FileNameListNotifier, List<SauceFile>>((ref) {
  return FileNameListNotifier();
});

class FileNameListNotifier extends StateNotifier<List<SauceFile>> {
  FileNameListNotifier() : super([]);
  void reset() {
    state = [];
    // TODO Clear cache
  }

  void add(SauceFile file) {
    state = [...state, file];
  }

  void refresh(List<SauceFile> files) {
    reset();
    for (final file in files) {
      state = [...state, file];
    }
  }

  num length() {
    return state.length;
  }

  List<SauceFile> nowState() {
    return state;
  }
}

dynamic filesProvider = StateNotifierProvider<FilesNotifier, List<File>>((ref) {
  return FilesNotifier();
});

class FilesNotifier extends StateNotifier<List<File>> {
  FilesNotifier() : super([]);
  void resetFiles() {
    state = [];
    // TODO Clear cache
  }

  void addFile(File file) {
    state = [...state, file];
  }

  void refreshFiles(List<File> files) {
    state = [];
    for (final file in files) {
      state = [...state, file];
    }
  }
}

dynamic pathNameProvider = StateProvider((ref) => "");

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

dynamic apiKeyProvider = StateProvider((ref) => "");
dynamic cidProvider = StateProvider((ref) => "");
dynamic downloadProvider = StateProvider((ref) => "");
dynamic cacheProvider = StateProvider((ref) => "");

// List() filesProviders = StateProvider(["create"]);

final sauceProvider = StateNotifierProvider<SauceNotifier, List<Sauce>>((ref) {
  return SauceNotifier();
});

class SauceNotifier extends StateNotifier<List<Sauce>> {
  SauceNotifier() : super([]);
  void resetSauce() {
    state = [];
  }

  void addSauce(Sauce sauce) {
    state = [...state, sauce];
  }

  void removeSauce(String _cid) {
    state = [
      for (final sauce in state)
        if (sauce.cid != _cid) sauce,
    ];
  }

  void nameModify(String _cid, String _newName) {
    state = [
      for (final sauce in state)
        if (sauce.cid == _cid) sauce.copyWith(filename: _newName) else sauce,
    ];
  }
}

final apiKeyProviderAsync = FutureProvider<String>((ref) async {
  return await FileFuns().readFile(apiFileNameConst);
});
