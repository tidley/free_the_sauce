import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_path_provider/android_path_provider.dart';

// Custom libs
import 'package:flutter_nft_storage/widgets/buttons.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_nft_storage/providers.dart';
import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_nft_storage/constants/constants.dart';
import 'package:flutter_nft_storage/widgets/sauce_list.dart';

class Home extends ConsumerWidget {
  final String apiKey;
  const Home({Key? key, required this.apiKey}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String _fileName = ref.watch(filenameProvider);
    final String _cid = ref.watch(cidProvider);

    Future<void> _init() async {
      // Load file
      await FileFuns().csvToRef(cacheFileName, ref);
    }

    _init();

    void _savedSauce(String name, String cid) async {
      String _time = DateTime.now().toString().substring(0, 19);
      String _dataString = "$_time,$name,$cid";
      Sauce _newSauce = Sauce(epoch: _time, filename: name, cid: cid);
      ref.read(sauceProvider.notifier).addSauce(_newSauce);
      await FileFuns().autoAppend(cacheFileName, _dataString);
    }

    void _select() async {
      await SelectSauce().openFileExplorer(ref);
    }

    void _upload() async {
      ref.watch(cidProvider.state).state = "Please wait...";
      try {
        final _file = ref.watch(fileProvider);
        final _dataString = await FileFuns().openFileString(_file);
        final _fileType = _file.split('.').last;
        Map<String, dynamic> response =
            await ApiCalls().upload(apiKey, _dataString, fileType: _fileType);
        final _cidDynamic = response["value"]["cid"];
        ref.watch(cidProvider.state).state = "Upload complete";
        _savedSauce(_fileName, _cidDynamic);
      } catch (e) {
        ref.watch(cidProvider.state).state = "Error: $e";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to upload file: Please check API key.'),
          ),
        );
      }
    }

    void _download() async {
      if (ref.read(downloadProvider) != "") {
        if (await Permission.storage.request().isGranted) {
          print(ref.read(downloadProvider));
          ref.watch(cidProvider.state).state = "Please wait...";
          // final _bearer = dotenv.get('BEARER');
          MyDataStorage _sourceData =
              await ApiCalls().getData(apiKey, ref.read(downloadProvider));
          if (_sourceData.extension != "") {
            File _savedSauce =
                await FileFuns().base64ToDownloads(_sourceData, ref);
            int size = await _savedSauce.length();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: size > 0 ? Colors.green : Colors.red,
                content: Text((size > 0
                    ? '${(await _savedSauce.length() / 1048576).toStringAsFixed(3)} MB saved to Downloads.'
                    : 'Failed to save file: Please check permissions.')),
              ),
            );
          } else {
            print("No data");
          }
          ref.watch(cidProvider.state).state = "Download complete";
        } else {
          openAppSettings();
        }
      } else
        (print("blank cid"));
    }

    void _test() async {
      String downloadsPath = await AndroidPathProvider.downloadsPath;

      print("downloadsPath");
      print(downloadsPath);
    }

    void _clearList() async {
      await FileFuns().resetFile(cacheFileName, ref);
      FilePicker.platform.clearTemporaryFiles().then((result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: result! ? Colors.green : Colors.red,
            content: Text((result
                ? 'Temporary files removed successfully.'
                : 'Failed to remove temporary files.')),
          ),
        );
      });
    }

    void _snackBar(String pass, String fail) async {}

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.2,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ButtonBox(
                    text: "Pick file...",
                    onpressed: _select,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(_fileName),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonBox(
                    text: "Upload",
                    onpressed: _upload,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(_cid),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      Form.of(primaryFocus!.context!)!.save();
                    },
                    child: Wrap(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'CID'),
                          style: TextStyle(fontSize: 13),
                          onSaved: (String? value) {
                            ref.read(downloadProvider.notifier).state = value;
                          },
                        ),
                      )
                    ]),
                  ),
                  ButtonBox(
                    text: "Download",
                    onpressed: _download,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonBox(
                    text: "Test",
                    onpressed: _test,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonBox(
                    text: "Clear",
                    onpressed: _clearList,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.4,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: const [
                  // SauceList3().saucesProvider
                  SauceList(),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
