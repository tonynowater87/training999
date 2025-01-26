import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training999/provider/name/all_name_provider.dart';
import 'package:training999/provider/name/is_name_existed_provider.dart';
import 'package:training999/provider/name/model/user_name.dart';
import 'package:training999/provider/name/text_changed_provider.dart';

class EnterNameWidget extends HookConsumerWidget {
  const EnterNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    var isNameExisted = useState(false);
    final screenWidth = MediaQuery.of(context).size.width;
    ref.listen(isNameExistedProvider, (previous, current) {
      isNameExisted.value = current.hasValue ? current.value! : false;
    });
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
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  helperText: 'It\'s used for ranking',
                  errorText: isNameExisted.value && isNameExisted.value == true
                      ? 'Name existed'
                      : null,
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (String? value) async {
                  debugPrint('[TONY] onFieldSubmitted: $value');
                  if (isNameExisted.value) {
                    return;
                  }
                  FocusScope.of(context).unfocus();
                  if (value != null && value.isNotEmpty) {
                    ref
                        .read(allNameProviderProvider.notifier)
                        .addName(value);
                  }
                },
                onChanged: (String value) {
                  ref.read(textChangedProvider.notifier).setName(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
