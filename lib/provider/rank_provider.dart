import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank.dart';
import 'package:training999/provider/rank_repository.dart';

part 'rank_provider.g.dart';

@riverpod
List<Rank> rankList(Ref ref) {
  final repo = ref.watch(rankRepositoryProvider);
  return repo.rankList;
}
