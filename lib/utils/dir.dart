import 'package:android_path_provider/android_path_provider.dart';

class DirInfo {
  Future<String> downloadsPath() async {
    return await AndroidPathProvider.downloadsPath;
  }
}
