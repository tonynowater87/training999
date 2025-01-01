import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/name_repository.dart';

part 'name_repository_provider.g.dart';

@Riverpod(keepAlive: true)
class NameRepositoryDebug extends _$NameRepositoryDebug {
  final NameRepository _nameRepository = NameRepository();

  @override
  Future<String?> build() async {
    return _nameRepository.getNameByAdvertisingIdentifier;
  }

  void setName(String name) {
    _nameRepository.setName(name); // TODO
    state = AsyncData(name);
  }
}
