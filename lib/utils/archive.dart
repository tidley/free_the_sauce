import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:archive/archive_io.dart';

class Archive {
  Future<bool> compressFiles(List<File> files, String filename) async {
    try {
      final ZipFileEncoder encoder = ZipFileEncoder();
      encoder.create(filename);
      for (var file in files) {
        print("compressing and adding ${file.path}");
        await encoder.addFile(file);
      }
      encoder.close();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
