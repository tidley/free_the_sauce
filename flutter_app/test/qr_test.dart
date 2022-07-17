import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
// Create qr

// Read from qr

void main() async {
  test('Writing QR code from data', () async {
    const data = "This is some test data to write to a QR device.";
    QrImage _qr = QrLib().qrImage(data);
    expect(_qr, "");
    // https://stackoverflow.com/questions/53078493/flutter-qrimage-convert-to-image
  });
}
