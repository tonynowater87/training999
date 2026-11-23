import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logs provider lifecycle events in debug builds only.
class MyProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    super.didAddProvider(provider, value, container);
    _log('Provider added: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    _log('Provider updated: ${provider.name ?? provider.runtimeType}, '
        'new value: $newValue');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    super.didDisposeProvider(provider, container);
    _log('Provider disposed: ${provider.name ?? provider.runtimeType}');
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[TONY] $message');
    }
  }
}
