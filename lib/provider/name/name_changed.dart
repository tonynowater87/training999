import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textChangedProvider =
    ChangeNotifierProvider((ref) => TextChangedProvider());

class TextChangedProvider extends ChangeNotifier {
  String _name = '';

  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}
