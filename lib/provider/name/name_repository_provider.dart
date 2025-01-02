import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/user_name.dart';

part 'name_repository_provider.g.dart';

class NameRepository {
  final List<UserName> _names = [];

  List<UserName> get names => _names;

  setName(UserName userName) {
    _names.add(userName);
  }
}

@Riverpod(keepAlive: true)
NameRepository nameRepository(Ref ref) {
  return NameRepository();
}
