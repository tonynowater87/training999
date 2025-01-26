import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/model/user_name.dart';
import 'package:training999/provider/uuid/get_uuid.dart';

part 'all_name_provider.g.dart';

@Riverpod(keepAlive: true)
class AllNameProvider extends _$AllNameProvider {

  @override
  Future<List<UserName>> build() async {
    return generateRandomNameList();
  }

  Future<void> addName(String userName) async {
    // TODO insert record to firestore
    // check if name is already exist
    List<UserName> allNames = state.value!.toList();
    if (allNames.where((element) => element.name == userName).isEmpty) {
      final uuid = await ref.read(getUuidProvider.future);
      allNames.add(UserName(uuid: uuid, name: userName));
      state = AsyncData(allNames);
    }
  }

  Future<List<UserName>> generateRandomNameList() async {
    // TODO listen from firestore
    return Future.delayed(const Duration(seconds: 1), () {
      final List<UserName> nameList = [];
      for (int i = 0; i < 10; i++) {
        nameList.add(UserName(uuid: i.toString(), name: 'Player $i'));
      }
      return nameList;
    });
  }
}
