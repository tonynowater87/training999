import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/model/user_name.dart';

part 'all_name_provider.g.dart';

@Riverpod(keepAlive: true)
class AllNameProvider extends _$AllNameProvider {

  @override
  Future<List<UserName>> build() async {
    return generateRandomNameList();
  }

  void addName(UserName userName) {
    // TODO insert record to firestore
    // check if name is already exist
    List<UserName> allNames = state.value!.toList();
    if (!allNames.contains(userName)) {
      allNames.add(userName);
      state = AsyncData(allNames);
    }
  }

  Future<List<UserName>> generateRandomNameList() async {
    // TODO listen from firestore
    return Future.delayed(const Duration(seconds: 5), () {
      final List<UserName> nameList = [];
      for (int i = 0; i < 10; i++) {
        nameList.add(UserName(uuid: i.toString(), name: 'Player $i'));
      }
      return nameList;
    });
  }
}
