import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:flutter_nft_storage/utils/utils.dart';

String bearer = "";
const cid =
    'bafkreibnvz5fjofzoiry2njflcy5fkyhppyl2wt4jfeadygai2op7g77hq'; //'bafkreic5v7ls2nkhzys5a7pymiauaz3bqp33j6pbgpjnfi56h4qh4y4bd4';
String? cidDynamic =
    'bafybeihxnlnok464hkfdbknzzv53vgwwijl6q4np4duk6us4f6novko5bq';
void main() async {
  setUp(() {
    dotenv.testLoad(fileInput: File('assets/.env').readAsStringSync());
    bearer = dotenv.env['BEARER'] ??= "";
  });
  // test('Checking connection to nft.storage', () async {
  //   String response = await ApiCalls().getStatus(bearer, cid);
  //   expect(response.contains('deals'), true);
  // });
  // test('Uploading string to nft.storage', () async {
  //   const body = '<file contents here a>';
  //   String response = await ApiCalls().upload(bearer, body);
  //   expect(response.contains(':true'), true);
  // });
  // test('Uploading file to nft.storage', () async {
  //   const path = 'test/image.png';
  //   final dataString = await FileFuns().openFileString('test/image.png');().
  // final fileType = path.split('.').last;
  // //   String fileType = fileSplit[fileSplit.length - 1];
  //   Map<String, dynamic> response =
  //       await ApiCalls().upload(bearer, dataString, fileType: fileType);
  //   cidDynamic = response["value"]["cid"];
  //   expect(cidDynamic?.contains('ba'), true);
  // });
  test('Retrieving from nft.storage', () async {
    MyDataStorage response =
        await ApiCalls().getData(bearer, cidDynamic ??= cid);
    final path = await FileFuns().saveFile(response, path: 'test/imageNew');
    expect(path, "test/imageNew.${response.extension}");
  });
  // test('Storage for app state', () async {
  //   String fileName = "flut.txt";
  //   String newData = "data35";
  //   await FileFuns().autoAppend(fileName, newData);
  // });

  // TODO
  // TODO https://www.geeksforgeeks.org/flutter-qr-code-scanner-and-qr-generator/
  // TODO https://stackoverflow.com/questions/56410086/flutter-how-to-create-a-zip-file
}
