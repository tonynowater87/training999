import 'package:flutter/foundation.dart';

// TODO FireStore
class NameRepository {
  List<String> names = [];
  int nameIndex = -1;
  String _userName = "";

  String get getNameByAdvertisingIdentifier => _userName;

  setName(String name) {
    nameIndex = names.indexOf(name);
    debugPrint('[TONY] nameIndex: $nameIndex, names: $names');
    if (nameIndex == -1) {
      names.add(name);
      nameIndex = names.length - 1;
      _userName = name;
    }
  }
}
