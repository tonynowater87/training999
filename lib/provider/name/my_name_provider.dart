import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/all_name_provider.dart';
import 'package:training999/provider/name/model/user_name.dart';

part 'my_name_provider.g.dart';

@riverpod
Future<UserName> myName(Ref ref) async {
  List<UserName> allNames = await ref.watch(allNameProviderProvider.future);
  const uuid = '100'; // TODO get uuid from something
  UserName myName = allNames.firstWhere((element) => element.uuid == uuid,
      orElse: () => const UserName(uuid: "", name: ""));
  return myName;
}
