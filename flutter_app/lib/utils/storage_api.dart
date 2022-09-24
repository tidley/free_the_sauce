import 'dart:convert';
import 'package:flutter_nft_storage/constants.dart';
import 'package:http/http.dart' as http;

///
import 'package:flutter_nft_storage/classes/classes.dart';

class ApiCalls {
  Future<String> uploadToCloud(
      String bearer, String data, String filename, String extension) async {
    var headers = {
      'Authorization': 'Bearer ' + bearer,
    };
    http.Request request =
        http.Request('POST', Uri.parse('https://api.nft.storage/upload'));
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
