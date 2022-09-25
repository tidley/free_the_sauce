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
    print(_uri);

    // final request = await HttpClient().getUrl(Uri.parse(_uri));
    // // var request = await http.get(Uri.parse(ipfsGateway + _cid));
    // final response = await request.close();
    // return await FileFuns().responseToDownload(response);

    String _downloadsPath = await DirInfo().downloadsPath();
    String fn = (DateTime.now().toIso8601String());
    fn = fn.replaceAll(':', '-');
    fn = '$_downloadsPath/${(fn.split('.').first)}.zip';
    print(fn);

    // final request = await HttpClient().getUrl(Uri.parse(ipfsGateway + _cid));
    // // var request = await http.get(Uri.parse(ipfsGateway + _cid));
    // final response = await request.close();
    // // File _sauce = await File('$_downloadsPath/$fn').create();
    // await response.pipe(File('$_downloadsPath/$fn').openWrite());
    // // File file = await FileFuns().fileLocalOpen('$_downloadsPath/$fn');
    // return File('$_downloadsPath/$fn');

    // response.pipe(File('foo.zip').openWrite());

    // if (!request.body.contains("invalid ipfs path")) {
    //   return base64.decode(request.body.toString());
    // } else {
    //   return ("");
    // }

    // var url = Uri.parse(_uri);
    // final utf8Decoder = utf8.decoder;

    // var httpClient = HttpClient();
    // httpClient.getUrl(url).then((HttpClientRequest request) {
    //   return request.close();
    // }).then((HttpClientResponse response) {
    //   response.transform(utf8Decoder.convert()).then((data) {
    //     var body = data.join('');
    //     print(body);
    //     var file = new File('foo.txt');
    //     file.writeAsString(body).then((_) {
    //       httpClient.close();
    //     });
    //   });
    // });

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
