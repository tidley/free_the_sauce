import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_nft_storage/constants.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_nft_storage/providers.dart';

class SelectSauce {
  Future<void> selectFiles(WidgetRef ref) async {
    try {
      // Get file paths
      List<String?>? _filePaths = (await FilePicker.platform.pickFiles(
        allowMultiple: true,
      ))
          ?.paths;
      // ref.read(fileNameListProvider.notifier).reset;
      if (_filePaths != null) {
        // Reset list
        ref.read(fileNameListProvider.notifier).reset();
        for (var _file in _filePaths) {
          if (_file != null) {
            ref.read(fileNameListProvider.notifier).add(_file);
          }
        }
      }
    } on PlatformException catch (e) {
      ref
          .read(fileNameListProvider.notifier)
          .add("Unsupported operation" + e.toString());
    } catch (ex) {
      ref.read(fileNameListProvider.notifier).add("ex.toString()");
    }
  }
}

class FilePrep {
  Future<void> upload(bool _combineZip, String apiKey, WidgetRef ref,
      dynamic _errorSnackbar) async {
    List<String> _fileNameList = ref.watch(fileNameListProvider);

    if (_fileNameList.isNotEmpty) {
      ref.watch(cidProvider.state).state = "Please wait...";
      // To zip or upload individually
      if (_combineZip) {
        await FileFuns().saveLocalZip(_fileNameList);
        // Update target filename
        _fileNameList = [await FileFuns().localZipPath()];
      } else {
        print("Single file please");
      }
      for (var _fileName in _fileNameList) {
        // Get / create name
        final String _cloudName = _combineZip
            ? '${DateTime.now().toString().substring(0, 19).toString()}.zip'
            : _fileName;
        ref.watch(cidProvider.state).state =
            "Uploading: ${_cloudName.split('/').last}";
        // Get data
        String _dataString = await FileFuns().openFileString(_fileName);
        // Upload
        if (_dataString != "failed") {
          String response = await ApiCalls().uploadToCloud(
              apiKey, _dataString, _cloudName, _cloudName.split('.').last);
          final _cidDynamic = await json.decode(response)["cid"];
          // Add to list
          FileFuns().appendSauce(_cloudName.split('/').last, _cidDynamic, ref);
        }
      }
      ref.watch(cidProvider.state).state = "Upload complete";
    }
  }

  Future<void> uploadArchive(
      String apiKey, WidgetRef ref, dynamic _errorSnackbar, dynamic gps) async {
    List<String> _fileNameList = ref.watch(fileNameListProvider);
    if (_fileNameList.isNotEmpty) {
      // Update UI
      ref.watch(cidProvider.state).state = "Please wait...";
      final dateTime = DateTime.now();
      // Metadata
      String metaDataFn = "metadata.txt";
      String metaData =
          "Time: $dateTime\nLat: ${gps["lat"]}\nLong: ${gps["long"]}";
      print(metaData);
      await FileFuns().writeFile(metaDataFn, metaData);
      // Prepare files for upload
      ref
          .read(fileNameListProvider.notifier)
          .add((await FileFuns().getLocalPath()) + '/' + metaDataFn);
      _fileNameList = ref.watch(fileNameListProvider);
      print("_fileNameList");
      print(_fileNameList);
      // Compress data and store
      await FileFuns().saveLocalZip(_fileNameList);
      String finalUploadName = await FileFuns().localZipPath();
      print(finalUploadName);
      String response = await ApiCalls().uploadFile(apiKey, finalUploadName);
      final _cidDynamic = await json.decode(response)["cid"];
      FileFuns().appendSauce(finalUploadName.split('/').last, _cidDynamic, ref);
    }
    ref.watch(cidProvider.state).state = "Upload complete";
  }
}
