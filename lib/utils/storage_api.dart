import 'dart:convert';
import 'package:http/http.dart' as http;

///
import 'package:flutter_nft_storage/classes/classes.dart';

class ApiCalls {
  Future<Map<String, dynamic>> upload(String bearer, String inputBody,
      {String fileType = "fileType"}) async {
    var headers = {
      'Authorization': 'Bearer ' + bearer,
    };
    var request =
        http.Request('POST', Uri.parse('https://api.nft.storage/upload'));
    request.body = '{"ext":"$fileType","data":"$inputBody"}';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await json.decode((await response.stream.bytesToString()).trim());
    } else {
      return await json.decode((response.reasonPhrase.toString()).trim());
    }
  }

  Future<String> getStatus(String bearer, String cid) async {
    var headers = {
      'Authorization': 'Bearer ' + bearer,
    };
    var request =
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
    const baseUrl = "https://ipfs.io/ipfs/";
    var request = await http.get(Uri.parse(baseUrl + cid));
    if (!request.body.contains("invalid ipfs path")) {
      MyDataStorage myData =
          MyDataStorage.fromJson(json.decode(request.body.toString()));
      return myData;
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
