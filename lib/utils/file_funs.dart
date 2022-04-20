import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter_nft_storage/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:flutter_nft_storage/classes/classes.dart';

class FileFuns {
  Future<Uint8List> openFileUint8(String? filename) async {
    final _fn = filename ??= 'test/test.txt';
    Uint8List uint8list = Uint8List.fromList(File(_fn).readAsBytesSync());
    print("done");
    return uint8list;
  }

  // https://www.fluttercampus.com/guide/182/encode-decode-path-file-bytes-base64-in-dart-flutter/
  Future<String> openFileString(String? filename) async {
    final _fn = filename ??= 'test/test.txt';
    File imgfile = File(_fn);
    Uint8List imgbytes = await imgfile.readAsBytes();
    String bs4str = base64.encode(imgbytes);
    return bs4str;
  }

  Future<String> saveFile(MyDataStorage sourceData,
      {String path = "test/imageNew"}) async {
    // if (sourceData.length % 4 > 0) {
    //   sourceData += '=' * (4 - sourceData.length % 4);
    // }
    Uint8List decodedbytes = base64.decode(sourceData.rawData);
    File decodedimgfile = await File(path + "." + sourceData.extension)
        .writeAsBytes(decodedbytes);
    return decodedimgfile.path;
  }

  Future<String> saveFileDownloads(MyDataStorage sourceData,
      {String path = "test/imageNew"}) async {
    // if (sourceData.length % 4 > 0) {
    //   sourceData += '=' * (4 - sourceData.length % 4);
    // }
    Uint8List decodedbytes = base64.decode(sourceData.rawData);
    File decodedimgfile = await File(path + "." + sourceData.extension)
        .writeAsBytes(decodedbytes);
    return decodedimgfile.path;
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> fileOpen(String? filename) async {
    final path = await FileFuns().getLocalPath();
    return File('$path/$filename');
  }

  Future<File> fileWrite(File file, String data) async {
    return file.writeAsString(data);
  }

  Future<void> writeFile(String filename, String data) async {
    File file = await FileFuns().fileOpen(filename);
    await FileFuns().fileWrite(file, data);
  }

  Future<String> readFile(String filename) async {
    File file = await FileFuns().fileOpen(filename);
    return await FileFuns().fileRead(file);
  }

  Future<String> fileRead(File file) async {
    if (await file.exists()) {
      try {
        return await file.readAsString();
      } catch (e) {
        return 'file.readAsString Error: $e';
      }
    } else {
      return "";
    }
  }

  Future<File> appendFile(File file, String data) async {
    String contents = (await FileFuns().fileRead(file)) + "\r\n$data";
    return await FileFuns().fileWrite(file, contents);
  }

  Future<void> autoAppend(String? filename, String data) async {
    File file = await FileFuns().fileOpen(filename);
    await FileFuns().appendFile(file, data);
  }

  Future<List<Sauce>> csvToList(String filename) async {
    List<Sauce> sauceList = [];
    File file = await FileFuns().fileOpen(filename);
    List<String> lines = (await FileFuns().fileRead(file)).split('\r\n');
    for (var sauce in lines) {
      List<String> _bits = sauce.split(',');
      if (_bits.length > 2 && _bits[1] != "filename") {
        sauceList.add(
          Sauce(epoch: _bits[0], filename: _bits[1], cid: _bits[2]),
        );
      }
    }
    return sauceList;
  }

  List<Sauce> _cache = [];

  Future<void> csvToRef(String filename, WidgetRef ref) async {
    List<Sauce> sauceList = await FileFuns().csvToList(filename);
    if (_cache != sauceList) {
      _cache = sauceList;
      ref.read(sauceProvider.notifier).resetSauce();
      for (Sauce item in sauceList) {
        ref.read(sauceProvider.notifier).addSauce(
              item,
            );
      }
    } else {
      print("Skipp");
    }
  }

  Future<void> resetFile(String filename, WidgetRef ref) async {
    File file = await FileFuns().fileOpen(filename);
    await FileFuns().fileWrite(file, 'epoch,filename,cid');
    ref.read(sauceProvider.notifier).resetSauce();
  }

  Future<File> base64ToDownloads(
      MyDataStorage _sourceData, WidgetRef ref) async {
    final _cid = ref.read(downloadProvider);
    final cid = _cid == ""
        ? "bafybeifb6juaycok634fh2yu7ucuq7gnkagwi5yisaa4z77q7jkxwgsan4"
        : _cid;
    String _downloadsPath = await AndroidPathProvider.downloadsPath;

    File _sauce =
        await File('$_downloadsPath/$cid.${_sourceData.extension}').create();
    Uint8List _decodedbytes = base64.decode(_sourceData.rawData);

    return await _sauce.writeAsBytes(_decodedbytes);
  }
}

/////////////////////////////////////
class FileHandler {
  final String _filePath;
  FileHandler(this._filePath);
  Future<Uint8List> _readToBytes() async {
    var file = File.fromUri(Uri.parse(_filePath));
    return await file.readAsBytes();
  }

  Future<Map<String, dynamic>> get data async {
    var byte = await _readToBytes();
    var ext = _filePath.split('.').last;
    return {'byte': byte, 'extension': ext};
  }
}
