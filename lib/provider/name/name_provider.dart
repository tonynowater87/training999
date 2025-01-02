import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/name_repository_provider.dart';
import 'package:training999/provider/name/user_name.dart';

part 'name_provider.g.dart';

@riverpod
List<UserName> userName(Ref ref) {
  final repo = ref.watch(nameRepositoryProvider);
  debugPrint('[TONY] name_provider.dart - userName() - repo.userName: ${repo.names}');
  return repo.names;
}
