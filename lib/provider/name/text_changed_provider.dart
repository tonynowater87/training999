import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_changed_provider.g.dart';

@Riverpod(keepAlive: true)
class TextChanged extends _$TextChanged {
  @override
  String build() {
    return "";
  }

  void setName(String name) {
    state = name;
  }
}
