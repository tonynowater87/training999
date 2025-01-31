import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_name.freezed.dart';

@Freezed()
class UserName with _$UserName {
  const factory UserName({
    required String uuid,
    required String name,
  }) = _UserName;

  factory UserName.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserName(
      uuid: data?['uuid'],
      name: data?['name'],
    );
  }
}

extension UserNameX on UserName {
  Map<String, dynamic> toFirestore() {
    return {
      "uuid": uuid,
      "name": name,
    };
  }
}