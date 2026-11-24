import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/name_repository.dart';
import 'package:training999/provider/name/text_changed_provider.dart';

part 'is_name_existed_provider.g.dart';

const _debounceDuration = Duration(milliseconds: 300);

@riverpod
Future<bool> isNameExisted(Ref ref) async {
  final text = ref.watch(textChangedProvider).trim();
  if (text.isEmpty) {
    return false;
  }

  // Debounce: typing rebuilds this provider and disposes the previous build,
  // so only the last value after a short pause hits Firestore.
  var isDisposed = false;
  ref.onDispose(() => isDisposed = true);
  await Future<void>.delayed(_debounceDuration);
  if (isDisposed) {
    return false;
  }

  return NameRepository.isNameTaken(text);
}
