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

///
/// Object eventually compressed as a .zip
///
class FileList {
  final List<VeriSauce> files;
  const FileList({required this.files});
}

///
/// This class describes the zipped folder layout
///
class VeriSauce {
  final DateTime date; // = DateTime.now();
  final String gps;
  final List<String> files;
  const VeriSauce({required this.date, required this.gps, required this.files});

  // zipIt(){
  //   return
  // }
}
