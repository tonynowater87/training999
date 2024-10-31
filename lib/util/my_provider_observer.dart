import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    super.didAddProvider(provider, value, container);
    print('Provider added: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    print(
        'Provider updated: ${provider.name ?? provider.runtimeType}, new value: $newValue');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    super.didDisposeProvider(provider, container);
    print('Provider disposed: ${provider.name ?? provider.runtimeType}');
  }
}
