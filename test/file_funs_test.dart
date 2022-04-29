// deps
import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

// uut
import 'package:flutter_nft_storage/utils/utils.dart';

// globals
String bearer = "";

void main() async {
  setUp(() {
    dotenv.testLoad(fileInput: File('assets/.env').readAsStringSync());
    bearer = dotenv.env['BEARER'] ??= "";
  });
  test('Compressing files', () async {
    final root = Directory.current;

    String outputName = '${root.path}/test/self.zip';

    // Generate list of files
    List<File> testFiles = [];
    await for (final entry in root.list(recursive: false)) {
      if (entry is! File) continue;
      final name = p.relative(entry.path, from: root.path);
      if (name.startsWith('.')) continue;
      if (name == outputName) continue;
      testFiles.add(entry);
      print(entry);
    }
    await Archive().compressFiles(testFiles, outputName);
  });
}
