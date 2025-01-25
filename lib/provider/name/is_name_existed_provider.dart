import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/all_name_provider.dart';
import 'package:training999/provider/name/text_changed_provider.dart';

part 'is_name_existed_provider.g.dart';

@riverpod
Future<bool> isNameExisted(Ref ref) async {
  final allNames = await ref.watch(allNameProviderProvider.future);
  final text = ref.watch(textChangedProvider);
  for (var element in allNames) {
    if (element.name == text) {
      return true;
    }
  }
  return false;
}
