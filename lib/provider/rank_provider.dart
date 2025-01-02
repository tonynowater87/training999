import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank.dart';
import 'package:training999/provider/rank_repository_provider.dart';

part 'rank_provider.g.dart';

@riverpod
List<Rank> rankList(Ref ref) {
  final repo = ref.watch(rankRepositoryProvider);
  debugPrint('[TONY] rank_provider.dart - rankList() - repo.rankList: ${repo.rankList}');
  return repo.rankList;
}
