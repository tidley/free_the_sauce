export 'sauce_class.dart';

class MyDataStorage {
  String filename;
  String extension;
  String rawData;

  MyDataStorage(this.filename, this.extension, this.rawData);

  factory MyDataStorage.fromJson(dynamic json) {
    return MyDataStorage(json['filename'] as String,
        json['extension'] as String, json['data'] as String);
  }

  @override
  String toString() {
    return '{ $extension, $rawData }';
  }
}
