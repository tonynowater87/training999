import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/model/user_name.dart';
import 'package:training999/provider/uuid/get_uuid.dart';

part 'all_name_provider.g.dart';

@Riverpod(keepAlive: true)
class AllNameProvider extends _$AllNameProvider {
  @override
  Future<List<UserName>> build() async {
    return getNameList();
  }

  Future<void> addName(String userName) async {
    final names = await getNameList();
    // check if name is already exist
    if (names.where((element) => element.name == userName).isEmpty) {
      final uuid = await ref.read(getUuidProvider.future);
      final docRef = FirebaseFirestore.instance.collection("names");
      await docRef.add(UserName(uuid: uuid, name: userName).toFirestore());
      state = AsyncData(await getNameList());
    }
  }

  Future<List<UserName>> getNameList() async {
    final docRef = FirebaseFirestore.instance.collection("names").withConverter(
        fromFirestore: UserName.fromFirestore,
        toFirestore: (UserName userName, options) => userName.toFirestore());
    final data = await docRef.get();
    final List<UserName> nameList = [];
    for (var element in data.docs) {
      nameList.add(element.data());
    }
    return nameList;
  }
}
