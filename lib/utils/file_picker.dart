import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nft_storage/constants/constants.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_nft_storage/providers.dart';

class SelectSauce {
  Future<void> openFileExplorer(bool _multiPick, WidgetRef ref) async {
    dynamic _path;
    dynamic _name;
    List<PlatformFile>? _paths;
    try {
      _paths = (await FilePicker.platform.pickFiles(
        allowMultiple: _multiPick,
      ))
          ?.files;

      ref.read(filesProvider.notifier).refreshFiles(
            _paths,
          );

      // if (multi) {
      //   List<PlatformFile>? files = (await FilePicker.platform.pickFiles(
      //     allowMultiple: true,
      //   ))
      //       ?.files;
      // } else {
      //   final _paths = (await FilePicker.platform.pickFiles(
      //     allowMultiple: multi,
      //   ))
      //       ?.files;
      //   // ref.watch(pathNameProvider.state).state =
      //   _path = _paths!.map((e) => e.path).toList()[0].toString();
      //   // ref.watch(fileNameProvider.state).state =
      //   _name = _paths.map((e) => e.name).toList()[0].toString();
      // }
    } on PlatformException catch (e) {
      _name = "Unsupported operation" + e.toString();
    } catch (ex) {
      _name = ex.toString();
    }
    print("_paths");
    print(_paths!.length);
    if (_paths.length > 0) {
      print("there are some paths");
      for (var _path in _paths) {
        print('Adding ${_path.path} to sources');
        // ref.read(filesProvider.notifier).addFile(File(_path.path.toString()));
        print('Added ${_path.path} to sources');
      }
      _path = _paths != null
          ? _paths.map((PlatformFile file) => file.path).toString()
          : '...';
      _name = _paths != null
          ? _paths.map((PlatformFile file) => file.name).toString()
          : '...';
      print("_path");
      print(_path);
      print("_name");
      print(_name);
      ref.watch(pathNameProvider.state).state = _path;
      ref.watch(fileNameProvider.state).state = _name;
    } else {
      print("there are not!! some paths");
    }
  }
}

class FilePrep {
  Future<void> upload(bool _combineZip, String apiKey, WidgetRef ref,
      dynamic _errorSnackbar) async {
    ref.watch(cidProvider.state).state = "Please wait...";
    String _files = ref.watch(pathNameProvider);

    List<File> _fileList = ref.watch(filesProvider);
    Map<String, dynamic>? response;
    String _fileName = "";
    try {
      if (_combineZip) {
        // TODO: Zip files, upload to ipfs
        await FileFuns().saveLocalZip(_fileList);
        final String _time = DateTime.now().toString().substring(0, 19);
        _fileName = '$_time.zip';
        response = await ApiCalls()
            .upload(apiKey, await FileFuns().openLocalZip(), _fileName, '.zip');
      } else {
        String _file = ref.watch(pathNameProvider);
        String _dataString = await FileFuns().openFileString(_file);

        List<String> _fileComponents = _file.split('.');
        for (var i = 0; i < _fileComponents.length - 1; i++) {
          _fileName += _fileComponents[i];
        }
        String _fileType = _file.split('.').last;
        response =
            await ApiCalls().upload(apiKey, _dataString, _fileName, _fileType);

        final _cidDynamic = response["value"]["cid"];
        ref.watch(cidProvider.state).state = "Upload complete";
        FileFuns().appendSauce(_fileName, _cidDynamic, ref);
      }
    } catch (e) {
      ref.watch(cidProvider.state).state = "Error: $e";
      _errorSnackbar;
    }
  }
}
