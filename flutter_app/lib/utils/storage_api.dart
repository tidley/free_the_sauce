import 'dart:convert';
import 'dart:io';
import 'package:flutter_nft_storage/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

///
import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_nft_storage/utils/utils.dart';

class ApiCalls {
  Future<String> uploadToCloud(
      String bearer, String data, String filename, String extension) async {
    var headers = {
      'Authorization': 'Bearer ' + bearer,
    };
    http.Request request =
        http.Request('POST', Uri.parse('https://api.web3.storage/upload'));
    request.body = '{"filename":"${filename.split('/').last}","data":"$data"}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final _response = (await response.stream.bytesToString()).trim();
      return _response;
    } else {
      print("Error in file upload");
      return (response.reasonPhrase.toString()).trim();
    }
  }

  Future<String> uploadFile(String bearer, String filename) async {
    var url = Uri.parse('https://api.web3.storage/upload');
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + bearer,
      "Content-Type": "multipart/form-data",
    }; // ignore this headers if there is no authentication
    http.MultipartRequest request = http.MultipartRequest("POST", url);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', filename);

    request.files.add(multipartFile);
    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();

    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    String response = await res.stream.bytesToString();
    return response.trim();
  }

  Future<String> getStatus(String bearer, String cid) async {
    var headers = {
      'Authorization': 'Bearer ' + bearer,
    };
    http.Request request =
        http.Request('GET', Uri.parse('https://api.nft.storage/' + cid));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase.toString();
    }
  }

  Future<MyDataStorage> getData(String bearer, String cid) async {
    final String _cid = cid.split(' ').last;
    print(_cid);

    var request = await http.get(Uri.parse(ipfsGateway + _cid));
    if (!request.body.contains("invalid ipfs path")) {
      return MyDataStorage.fromJson(json.decode(request.body.toString()));
    } else {
      return MyDataStorage("", "");
    }
  }

  Future<File> getDataDirect(String cid) async {
    final String _uri = '$ipfsGateway${cid.split(' ').last}';

    String _downloadsPath = await DirInfo().downloadsPath();
    String fn = (DateTime.now().toIso8601String());
    fn = fn.replaceAll(':', '-');
    fn = '$_downloadsPath/${(fn.split('.').first)}.zip';

    Response response = await get(Uri.parse(_uri));
    File file = File(fn);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<String> getDid(String bearer) async {
    var request = http.Request('GET', Uri.parse('https://api.nft.storage/did'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase.toString();
    }
  }
}
