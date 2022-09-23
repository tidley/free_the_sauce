// deps
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

// globals
String bearer = "";

void main() async {
  setUp(() {
    dotenv.testLoad(fileInput: File('assets/.env').readAsStringSync());
    bearer = dotenv.env['BEARER'] ??= "";
  });
  test('Uploading multi to web3.storage', () async {
    final fn =
        '/home/tom/Code/Personal/220325-flutter-nft-storage/free_the_sauce/flutter_app/test/self.zip';
    String _dataString = await FileFuns().openFileString(fn);
  });
}
