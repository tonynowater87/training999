import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/name_repository_provider.dart';

part 'name_provider.g.dart';

@riverpod
String? name(Ref ref) {
  final repo = ref.watch(nameRepositoryDebugProvider);
  return repo.value;
}
