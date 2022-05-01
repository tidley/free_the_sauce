import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nft_storage/constants/constants.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_nft_storage/providers.dart';

class SelectSauce {
  Future<void> selectFiles(bool _multiPick, WidgetRef ref) async {
    try {
      // dynamic _filesObjs = (await FilePicker.platform.pickFiles(
      //   allowMultiple: _multiPick,
      // ));
      // dynamic _fileNames = _filesObjs?.names;

      // Get file paths
      List<String?>? _filePaths = (await FilePicker.platform.pickFiles(
        allowMultiple: _multiPick,
      ))
          ?.paths;
      // Reset variables
      String _fnames = "";
      ref.read(filesProvider.notifier).resetFiles();
      for (var _file in _filePaths!) {
        if (_file != null) {
          print('Adding $_file to files list');
          // // Old bit
          // ref.read(filesProvider.notifier).addFile(
          //       File(
          //         _file,
          //       ),
          //     );
          // New bit
          ref.read(fileNameListProvider.notifier).add(_file);
          print('Added $_file to files list');
          // Filenames for frontend
          String _fname = _file.split('/').last;
          _fnames = _fnames == "" ? _fname : _fnames += ' +++ ' + _fname;
        }
      }
      ref.watch(fileNameProvider.state).state = _fnames;
    } on PlatformException catch (e) {
      ref.watch(fileNameProvider.state).state =
          "Unsupported operation" + e.toString();
    } catch (ex) {
      ref.watch(fileNameProvider.state).state = ex.toString();
    }
  }
}

class FilePrep {
  Future<void> upload(bool _combineZip, String apiKey, WidgetRef ref,
      dynamic _errorSnackbar) async {
    ref.watch(cidProvider.state).state = "Please wait...";
    // String _files = ref.watch(pathNameProvider);

    List<String> _fileNameList = ref.watch(fileNameListProvider);

    if (_fileNameList.isNotEmpty) {
      // To zip or upload individually
      if (_combineZip) {
        await FileFuns().saveLocalZip(_fileNameList);
        // Update target filename
        _fileNameList = [await FileFuns().localZipPath()];
      } else {
        print("Single file please");
      }
      for (var _fileName in _fileNameList) {
        // Get data
        String _dataString = await FileFuns().openFileString(_fileName);
        final String _cloudName = _combineZip
            ? DateTime.now().toString().substring(0, 19) + '.zip'
            : _fileName;
        Future<Map<String, dynamic>> response = ApiCalls().uploadToCloud(
            apiKey, _dataString, _cloudName, _cloudName.split('.').last);
        print("await response.toString()");
        print(await response.toString());
        final _cidDynamic = "response.value.cid";

        FileFuns().appendSauce(_fileName, _cidDynamic, ref);
      }
      ref.watch(cidProvider.state).state = "Upload complete";
    }

// Loop through and upload

    // Map<String, dynamic>? response;
    // String _fileName = "";
    // try {
    //   if (_combineZip) {
    //     // TODO: Zip files, upload to ipfs
    //     await FileFuns().saveLocalZip(_fileList);
    //     final String _time = DateTime.now().toString().substring(0, 19);
    //     _fileName = '$_time.zip';
    //     response = await ApiCalls()
    //         .upload(apiKey, await FileFuns().openLocalZip(), _fileName, '.zip');
    //   } else {
    //     String _file = ref.watch(pathNameProvider);
    //     String _dataString = await FileFuns().openFileString(_file);

    //     List<String> _fileComponents = _file.split('.');
    //     for (var i = 0; i < _fileComponents.length - 1; i++) {
    //       _fileName += _fileComponents[i];
    //     }
    //     String _fileType = _file.split('.').last;
    //     response =
    //         await ApiCalls().upload(apiKey, _dataString, _fileName, _fileType);

    //     final _cidDynamic = response["value"]["cid"];
    //     ref.watch(cidProvider.state).state = "Upload complete";
    //     FileFuns().appendSauce(_fileName, _cidDynamic, ref);
    //   }
    // } catch (e) {
    //   ref.watch(cidProvider.state).state = "Error: $e";
    //   _errorSnackbar;
    // }
  }
}
