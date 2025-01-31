import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rank.freezed.dart';

@freezed
class Rank with _$Rank {
  const factory Rank({
    required int id,
    required String name,
    required int survivedTimeInMilliseconds,
    required int brilliantlyDodgedTheBullets,
    required Timestamp createdAt,
    required String platform,
  }) = _Rank;

  factory Rank.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Rank(
      id: data?['id'],
      name: data?['name'],
      survivedTimeInMilliseconds: data?['survivedTimeInMilliseconds'],
      brilliantlyDodgedTheBullets: data?['brilliantlyDodgedTheBullets'],
      createdAt: data?['createdAt'],
      platform: data?['platform'],
    );
  }
}

extension RankX on Rank {
  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "survivedTimeInMilliseconds": survivedTimeInMilliseconds,
      "brilliantlyDodgedTheBullets": brilliantlyDodgedTheBullets,
      "createdAt": createdAt,
      "platform": platform,
    };
  }
}
