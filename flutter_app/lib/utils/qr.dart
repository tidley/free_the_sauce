import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrLib {
  QrImage qrImage(String data) {
    return QrImage(
        data: data, version: QrVersions.auto, size: 320, gapless: false);
  }

  // Future<Uint8List> createImageFromRenderKey(
  //     {GlobalKey<State<StatefulWidget>>? renderKey}) async {
  //   try {
  //     final RenderRepaintBoundary boundary = renderKey?.currentContext
  //         ?.findRenderObject()! as RenderRepaintBoundary;
  //     final ui.Image image = await boundary.toImage(pixelRatio: 3);
  //     final ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);

  //     return byteData!.buffer.asUint8List();
  //   } catch (_) {
  //     rethrow;
  //   }
  // }
}
