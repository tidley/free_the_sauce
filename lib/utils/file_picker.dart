import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_nft_storage/providers.dart';

class SelectSauce {
  Future<void> openFileExplorer(WidgetRef ref) async {
    String _path = "";
    String _name = "";
    try {
      final _paths = (await FilePicker.platform.pickFiles())?.files;
      // ref.watch(fileProvider.state).state =
      _path = _paths!.map((e) => e.path).toList()[0].toString();
      // ref.watch(filenameProvider.state).state =
      _name = _paths.map((e) => e.name).toList()[0].toString();
    } on PlatformException catch (e) {
      _name = "Unsupported operation" + e.toString();
    } catch (ex) {
      _name = ex.toString();
    }
    ref.watch(fileProvider.state).state = _path;
    ref.watch(filenameProvider.state).state = _name;
  }
}
