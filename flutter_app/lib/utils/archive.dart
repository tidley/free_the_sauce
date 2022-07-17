import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:archive/archive_io.dart';

class Archive {
  Future<bool> compressFiles(List<String> filenames, String filename) async {
    try {
      final ZipFileEncoder encoder = ZipFileEncoder();
      encoder.create(filename);
      for (var _filename in filenames) {
        print("compressing and adding $_filename");
        await encoder.addFile(File(_filename));
      }
      encoder.close();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
