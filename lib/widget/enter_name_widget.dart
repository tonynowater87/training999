import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training999/art/ui_theme.dart';
import 'package:training999/provider/name/is_name_existed_provider.dart';
import 'package:training999/provider/name/my_name_provider.dart';
import 'package:training999/provider/name/name_repository.dart';
import 'package:training999/provider/name/text_changed_provider.dart';
import 'package:training999/widget/ranking_list_widget.dart';

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
        submitError.value = registered ? null : '這個名稱已經有人使用';
      } catch (error) {
        debugPrint('[EnterNameWidget] Failed to register name: $error');
        submitError.value = '網路錯誤，請再試一次';
      } finally {
        isSubmitting.value = false;
      }
    }

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final errorText = isNameExisted ? '這個名稱已經有人使用' : submitError.value;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: UiColors.cyan.withValues(alpha: 0.5)),
    );

    return Padding(
      // The game canvas ignores the keyboard, so move the card above it.
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Align(
        alignment: keyboardHeight > 0
            ? Alignment.bottomCenter
            : const Alignment(0, 0.65),
        child: Container(
          width: max(320, screenWidth / 3),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
          decoration: neonPanelDecoration(UiColors.cyan),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PILOT REGISTRATION',
                  style: TextStyle(
                    color: UiColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                    shadows: neonGlow(UiColors.cyan),
                  )),
              const SizedBox(height: 2),
              const Text('輸入飛行員名稱，將顯示在排行榜上',
                  style: TextStyle(color: UiColors.textDim, fontSize: 12)),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: !isSubmitting.value,
                      maxLength: NameRepository.maxNameLength,
                      cursorColor: UiColors.cyan,
                      style:
                          const TextStyle(color: UiColors.text, fontSize: 16),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: '飛行員名稱',
                        hintStyle: const TextStyle(color: UiColors.textFaint),
                        counterStyle: const TextStyle(
                            color: UiColors.textFaint, fontSize: 10),
                        errorText: errorText,
                        errorStyle: const TextStyle(color: UiColors.pink),
                        filled: true,
                        fillColor: Colors.black.withValues(alpha: 0.3),
                        enabledBorder: border,
                        focusedBorder: border.copyWith(
                            borderSide: const BorderSide(
                                color: UiColors.cyan, width: 1.5)),
                        errorBorder: border.copyWith(
                            borderSide: const BorderSide(color: UiColors.pink)),
                        focusedErrorBorder: border.copyWith(
                            borderSide: const BorderSide(
                                color: UiColors.pink, width: 1.5)),
                        disabledBorder: border,
                      ),
                      onSubmitted: submit,
                      onChanged: (String value) {
                        submitError.value = null;
                        ref.read(textChangedProvider.notifier).setName(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 44,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: UiColors.cyan,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor:
                            UiColors.cyan.withValues(alpha: 0.25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: isSubmitting.value || isNameExisted
                          ? null
                          : () => submit(controller.text),
                      child: isSubmitting.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black))
                          : const Text('登錄',
                              style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
