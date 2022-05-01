import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_nft_storage/constants/constants.dart';
import 'package:flutter_nft_storage/providers.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:tar/tar.dart';
import 'package:path/path.dart' as p;

import 'package:flutter_nft_storage/classes/classes.dart';

class FileFuns {
  Future<Uint8List> openFileUint8(String? filename) async {
    final _filename = filename ??= 'test/test.txt';
    Uint8List uint8list = Uint8List.fromList(File(_filename).readAsBytesSync());
    print("done");
    return uint8list;
  }

  // https://www.fluttercampus.com/guide/182/encode-decode-path-file-bytes-base64-in-dart-flutter/
  Future<String> openFileString(String? filename) async {
    final String _filename = filename ??= 'test/test.txt';
    print("_filename");
    print(_filename);
    File imgfile = File(_filename);
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
    final _cid = ref.read(downloadProvider);
    final cid = _cid == ""
        ? "bafybeifb6juaycok634fh2yu7ucuq7gnkagwi5yisaa4z77q7jkxwgsan4"
        : _cid;
    String _downloadsPath = await DirInfo().downloadsPath();

    File _sauce = await File(
            '$_downloadsPath/${_sourceData.filename}.${_sourceData.extension}')
        .create();
    Uint8List _decodedbytes = base64.decode(_sourceData.rawData);

    return await _sauce.writeAsBytes(_decodedbytes);
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

  //////

  String compressSauce(String originalString) {
    final List<int> enCodedString = utf8.encode(originalString);
    final List<int> gZipString = gzip.encode(enCodedString);
    final String base64String = base64.encode(gZipString);
    return base64String;
  }

  String decompressSauce(String base64String) {
    final Uint8List decodeBase64Json = base64.decode(base64String);
    final List<int> decodegZipString = gzip.decode(decodeBase64Json);
    final String originalString = utf8.decode(decodegZipString);
    return originalString;
  }

  Future<String> openLocalZip() async {
    final String _localPath = await FileFuns().getLocalPath();
    return await FileFuns().readFile(_localPath + '/' + tempZip);
  }

  Stream<TarEntry> compressSauces(WidgetRef ref) async* {
    final root = Directory.current;
    List<File> sauces = ref.read(filesProvider.notifier).state;
    for (final File entry in sauces) {
      final name = p.relative(entry.path, from: root.path);

      final stat = entry.statSync();

      yield TarEntry(
        TarHeader(
          name: name,
          typeFlag: TypeFlag.reg, // It's a regular file
          // Apart from that, copy over meta information
          mode: stat.mode,
          modified: stat.modified,
          accessed: stat.accessed,
          changed: stat.changed,
          // This assumes that the file won't change until we're writing it into
          // the archive later, since then the size might be wrong. It's more
          // efficient though, since the tar writer would otherwise have to buffer
          // everything to find out the size.
          size: stat.size,
        ),
        // Use entry.openRead() to obtain an input stream for the file that the
        // writer will use later.
        entry.openRead(),
      );
    }
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
