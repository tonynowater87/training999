import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training999/provider/name/is_name_existed_provider.dart';
import 'package:training999/provider/name/my_name_provider.dart';
import 'package:training999/provider/name/name_repository.dart';
import 'package:training999/provider/name/text_changed_provider.dart';

// TODO 要怎麼在Widget裡取得GameReference呢？
class EnterNameWidget extends HookConsumerWidget {
  const EnterNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final isSubmitting = useState(false);
    final submitError = useState<String?>(null);
    final isNameExisted = ref.watch(isNameExistedProvider).valueOrNull ?? false;
    final screenWidth = MediaQuery.of(context).size.width;

    Future<void> submit(String value) async {
      final name = value.trim();
      if (name.isEmpty || isNameExisted || isSubmitting.value) {
        return;
      }
      FocusScope.of(context).unfocus();
      isSubmitting.value = true;
      try {
        final registered =
            await ref.read(myNameProvider.notifier).register(name);
        submitError.value = registered ? null : 'Name existed';
      } catch (error) {
        debugPrint('[EnterNameWidget] Failed to register name: $error');
        submitError.value = 'Network error, please try again';
      } finally {
        isSubmitting.value = false;
      }
    }

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
                enabled: !isSubmitting.value,
                maxLength: NameRepository.maxNameLength,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  helperText: 'It\'s used for ranking',
                  errorText: isNameExisted ? 'Name existed' : submitError.value,
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: submit,
                onChanged: (String value) {
                  submitError.value = null;
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
