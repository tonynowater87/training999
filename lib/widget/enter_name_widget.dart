import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training999/provider/name/all_name_provider.dart';
import 'package:training999/provider/name/is_name_existed_provider.dart';
import 'package:training999/provider/name/model/user_name.dart';
import 'package:training999/provider/name/my_name_provider.dart';
import 'package:training999/provider/name/name_changed.dart';

final combinedProvider = FutureProvider.autoDispose((ref) async {
  var myName = await ref.watch(myNameProvider.future);
  var isNameExisted = await ref.watch(isNameExistedProvider.future);
  return MapEntry(myName, isNameExisted);
});

class EnterNameWidget extends HookConsumerWidget {
  const EnterNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();

    var screenWidth = MediaQuery.of(context).size.width;
    var state = ref.watch(combinedProvider);
    return state.when(data: (data) {
      debugPrint('[TONY] data: $data');
      final isNameExisted = data.value;
      // TODO 一打完一個字輸入框就會收起來..
      return Center(
        child: Container(
          width: screenWidth / 3,
          padding: const EdgeInsets.only(bottom: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter your name first',
                    style: TextStyle(color: Colors.white)),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    helperText: 'It\'s used for ranking',
                    errorText: isNameExisted ? 'Name already existed' : null,
                    hintStyle: TextStyle(
                        color: isNameExisted ? Colors.red : Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (String? value) async {
                    if (value != null && value.isNotEmpty) {
                      ref
                          .read(allNameProviderProvider.notifier)
                          .addName(UserName(name: value, uuid: '100'));
                    }
                  },
                  onChanged: (String value) {
                    debugPrint('[TONY] onChanged: $value');
                    ref.read(textChangedProvider.notifier).setName(value);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }, loading: () {
      debugPrint('[TONY] loading');
      return const Center(child: CircularProgressIndicator());
    }, error: (error, stackTrace) {
      debugPrint('[TONY] error: $error');
      return const SizedBox.shrink();
    });
  }
}
