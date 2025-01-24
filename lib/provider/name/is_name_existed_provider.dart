import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/all_name_provider.dart';
import 'package:training999/provider/name/name_changed.dart';

part 'is_name_existed_provider.g.dart';

@Riverpod()
Future<bool> isNameExisted(Ref ref) async {
  final allNames = await ref.watch(allNameProviderProvider.future);
  final text = ref.watch(textChangedProvider);
  debugPrint('[TONY] text: ${text.name}, allNames: $allNames');
  for (var element in allNames) {
    if (element.name == text.name) {
      return true;
    }
  }
  return false;
}
