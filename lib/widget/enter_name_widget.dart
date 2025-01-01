import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training999/provider/name/name_repository_provider.dart';

class EnterNameWidget extends ConsumerWidget {
  const EnterNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth / 3,
        padding: const EdgeInsets.only(bottom: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter your name first',
                  style: TextStyle(color: Colors.white)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Your name,',
                  helperText: 'It\'s used for ranking',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (String? value) async {
                  if (value != null && value.isNotEmpty) {
                    ref.read(nameRepositoryDebugProvider.notifier).setName(value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
