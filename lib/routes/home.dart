import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

// Custom libs
import 'package:flutter_nft_storage/widgets/widgets.dart';
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
    List<String> _filePaths = ref.watch(fileNameListProvider);

    final String _cid = ref.watch(cidProvider);

    // There must be a better way than "_init()" ?
    Future<void> _init() async {
      // Load file
      await FileFuns().csvToRef(cachedFileList, ref);
    }

    _init();

    void _select() async {
      await SelectSauce().selectFiles(ref);
    }

    void _uploadFail() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to upload file: Please check API key.'),
        ),
      );
    }

    void _download() async {
      if (ref.read(downloadProvider) != "") {
        if (await Permission.storage.request().isGranted) {
          ref.watch(cidProvider.state).state = "Please wait...";
          // final _bearer = dotenv.get('BEARER');
          MyDataStorage _sourceData =
              await ApiCalls().getData(apiKey, ref.read(downloadProvider));
          if (_sourceData.filename != "") {
            File _appendSauce =
                await FileFuns().base64ToDownloads(_sourceData, ref);
            int size = await _appendSauce.length();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: size > 0 ? Colors.green : Colors.red,
                content: Text((size > 0
                    ? '${(await _appendSauce.length() / 1048576).toStringAsFixed(3)} MB saved to Downloads.'
                    : 'Failed to save file: Please check permissions.')),
              ),
            );
            ref.watch(cidProvider.state).state = "Download complete";
          } else {
            ref.watch(cidProvider.state).state = "Invalid request";
          }
        } else {
          openAppSettings();
        }
      } else
        (print("blank cid"));
    }

    void _clearList() async {
      await FileFuns().resetFile(cachedFileList, ref);
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

    dynamic _checkClear() {
      if (ref.watch(sauceProvider).isNotEmpty) {
        return Alerts().checkClear(context, _clearList);
      }
    }

    Column _fileNameList() {
      List<Text> _fileNames = [];
      //      ref.read(fileNameListProvider.notifier).reset();

      for (var _filePath in _filePaths) {
        _fileNames.add(Text(_filePath.toString().split('/').last));
      }
      //  ref.read(fileNameListProvider.notifier).reset;
      return Column(children: _fileNames);
    }

    TextStyle buttonStyle() {
      return ref.watch(sauceProvider).isNotEmpty ? btnText : btnTextDisabled;
    }

    TextButton primaryFunctionButton(String _text, _onPressed) {
      return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return null;
              } else {
                return Theme.of(context).colorScheme.primary;
              }
            },
          ),
        ),
        child: Text(
          _text,
          style: btnTextPrimary,
        ),
        onPressed: _onPressed,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.15,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      primaryFunctionButton(
                          'Select files from storage', _select),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        _fileNameList(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      WideButton(
                          text: "Upload 1-by-1",
                          onpressed: () => {
                                FilePrep()
                                    .upload(false, apiKey, ref, _uploadFail),
                              }),
                      WideButton(
                          text: "Zip-upload",
                          onpressed: () => {
                                FilePrep()
                                    .upload(true, apiKey, ref, _uploadFail),
                              }),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                    child: Text(
                      _cid,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                          style: const TextStyle(fontSize: 13),
                          onSaved: (String? value) {
                            ref.read(downloadProvider.notifier).state = value;
                          },
                        ),
                      )
                    ]),
                  ),
                  WideButton(
                    text: "Download",
                    onpressed: _download,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.4,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      // shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      children: const [
                        SauceList(),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    child: Text(
                      'CLEAR LIST',
                      style: buttonStyle(),
                    ),
                    onPressed: _checkClear,
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
