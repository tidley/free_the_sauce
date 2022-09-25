import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_nft_storage/constants.dart';
import 'package:flutter_nft_storage/providers.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:flutter_nft_storage/classes/classes.dart';

class FileFuns {
  // https://www.fluttercampus.com/guide/182/encode-decode-path-file-bytes-base64-in-dart-flutter/
  Future<String> openFileString(String? filename) async {
    final String _filename = filename ??= 'test/test.txt';
    print("_filename");
    print(_filename);
    File imgfile = File(_filename);
    try {
      Uint8List imgbytes = await imgfile.readAsBytes();
      String bs4str = base64.encode(imgbytes);
      return bs4str;
    } catch (e) {
      print(e.toString());
      return "failed";
    }
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> fileLocalOpen(String? filename) async {
    final path = await FileFuns().getLocalPath();
    return File('$path/$filename');
  }

  Future<void> writeFile(String filename, String data) async {
    File file = await FileFuns().fileLocalOpen(filename);
    await file.writeAsString(data);
  }

  Future<String> readFile(String filename) async {
    File file = await FileFuns().fileLocalOpen(filename);
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
    String _data = (await FileFuns().fileRead(file)) + "\r\n$data";
    return await file.writeAsString(_data);
  }

  Future<void> autoAppend(String? filename, String data) async {
    File file = await FileFuns().fileLocalOpen(filename);
    await FileFuns().appendFile(file, data);
  }

  Future<List<Sauce>> csvToList(String filename) async {
    List<Sauce> sauceList = [];
    File file = await FileFuns().fileLocalOpen(filename);
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
      print("Updating cache");
      _cache = sauceList;
      ref.read(sauceProvider.notifier).resetSauce();
      for (Sauce item in sauceList) {
        ref.read(sauceProvider.notifier).addSauce(
              item,
            );
      }
    }
  }

  Future<void> resetFile(String filename, WidgetRef ref) async {
    File file = await FileFuns().fileLocalOpen(filename);
    await file.writeAsString('epoch,filename,cid');
    ref.read(sauceProvider.notifier).resetSauce();
  }

  Future<File> base64ToDownloads(
      MyDataStorage _sourceData, WidgetRef ref) async {
    String _downloadsPath = await DirInfo().downloadsPath();
    String fn = _sourceData.filename.replaceAll(' ', '_');
    fn = _sourceData.filename.replaceAll(':', '-');
    File _sauce = await File('$_downloadsPath/$fn')
        // '$_downloadsPath/file.zip')
        .create();
    Uint8List _decodedbytes = base64.decode(_sourceData.rawData);
    return await _sauce.writeAsBytes(_decodedbytes);
  }

  Future<File> responseToDownload(HttpClientResponse response) async {
    String _downloadsPath = await DirInfo().downloadsPath();
    String fn = (DateTime.now().toIso8601String());
    fn = fn.replaceAll(':', '-');
    fn = '${(fn.split('.').first)}.zip';
    print(fn);
    File _sauce = await File('$_downloadsPath/$fn').create();
    await response.pipe(_sauce.openWrite());
    // File file = await FileFuns().fileLocalOpen('$_downloadsPath/$fn');
    return _sauce;
  }

  void appendSauce(String _name, String _cid, WidgetRef ref) async {
    final String _time = DateTime.now().toString().substring(0, 19);
    final String _dataString = "$_time,$_name,$_cid";
    final Sauce _newSauce = Sauce(epoch: _time, filename: _name, cid: _cid);
    ref.read(sauceProvider.notifier).addSauce(_newSauce);
    await FileFuns().autoAppend(cachedFileList, _dataString);
  }

  Future<bool> saveLocalZip(List<String> filenames) async {
    return await Archive().compressFiles(filenames, await localZipPath());
  }

  Future<String> localZipPath() async {
    return await FileFuns().getLocalPath() + '/' + tempZip;
  }
}
