
import 'package:flutter/material.dart';

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

