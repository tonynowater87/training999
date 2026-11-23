import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/model/user_name.dart';
import 'package:training999/provider/name/name_repository.dart';
import 'package:training999/provider/uuid/get_uuid.dart';

part 'my_name_provider.g.dart';

/// The name registered for this device. An empty name means "not registered".
@Riverpod(keepAlive: true)
class MyName extends _$MyName {
  @override
  Future<UserName> build() async {
    final uuid = await ref.watch(getUuidProvider.future);
    final userName = await NameRepository.findByUuid(uuid);
    return userName ?? UserName(uuid: uuid, name: '');
  }

  /// Registers [name] for this device.
  ///
  /// Returns false when the name is already used by another player.
  Future<bool> register(String name) async {
    // Check again right before writing; the value shown while typing may be
    // outdated by now.
    if (await NameRepository.isNameTaken(name)) {
      return false;
    }
    final uuid = await ref.read(getUuidProvider.future);
    final userName = UserName(uuid: uuid, name: name);
    await NameRepository.add(userName);
    state = AsyncData(userName);
    return true;
  }
}
