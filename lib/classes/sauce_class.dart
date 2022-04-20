import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Sauce {
  final String epoch;
  final String filename;
  final String cid;

  const Sauce({required this.epoch, required this.filename, required this.cid});

  Sauce copyWith({String? epoch, String? filename, String? cid}) {
    return Sauce(
        epoch: epoch ?? this.epoch,
        filename: filename ?? this.filename,
        cid: cid ?? this.cid);
  }
}

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
