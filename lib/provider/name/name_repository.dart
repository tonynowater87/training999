import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training999/provider/name/model/user_name.dart';

/// Firestore access for the `names` collection.
///
/// Every method runs a targeted query instead of downloading the whole
/// collection, so the cost does not grow with the number of players.
class NameRepository {
  NameRepository._();

  static const int maxNameLength = 20;

  static CollectionReference<UserName> get _collection =>
      FirebaseFirestore.instance.collection('names').withConverter(
          fromFirestore: UserName.fromFirestore,
          toFirestore: (UserName userName, options) => userName.toFirestore());

  static Future<UserName?> findByUuid(String uuid) async {
    final snapshot =
        await _collection.where('uuid', isEqualTo: uuid).limit(1).get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  static Future<bool> isNameTaken(String name) async {
    final snapshot =
        await _collection.where('name', isEqualTo: name).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  static Future<void> add(UserName userName) async {
    await _collection.add(userName);
  }
}
