export 'sauce_class.dart';

class MyDataStorage {
  String extension;
  String rawData;

  MyDataStorage(this.extension, this.rawData);

  factory MyDataStorage.fromJson(dynamic json) {
    return MyDataStorage(json['ext'] as String, json['data'] as String);
  }

  @override
  String toString() {
    return '{ $extension, $rawData }';
  }
}

