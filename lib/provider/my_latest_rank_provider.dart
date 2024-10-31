
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank.dart';
import 'package:training999/provider/rank_repository_provider.dart';

part 'my_latest_rank_provider.g.dart';

@riverpod
Rank? myLatestRank(Ref ref) {
  return ref.read(rankRepositoryProvider).getLatestRank;
}