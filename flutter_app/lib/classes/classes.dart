export 'sauce_class.dart';

class MyDataStorage {
  String filename;
  String rawData;

  MyDataStorage(this.filename, this.rawData);

  factory MyDataStorage.fromJson(dynamic json) {
    return MyDataStorage(json['filename'] as String,
        json['data'] as String);
  }

  @override
  String toString() {
    return '{ $filename, $rawData }';
  }
}
