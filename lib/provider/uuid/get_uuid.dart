
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'get_uuid.g.dart';

@Riverpod(keepAlive: true)
FlutterSecureStorage getSecureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@Riverpod(keepAlive: true)
Future<String> getUuid(Ref ref) async {

  FlutterSecureStorage secureStorage = ref.read(getSecureStorageProvider);

  // 嘗試從 Secure Storage 中讀取唯一碼
  String? deviceId = await secureStorage.read(key: 'device_id');

  if (deviceId == null) {
    // 如果不存在，則生成一個新的 UUID
    deviceId = const Uuid().v4();
    await secureStorage.write(key: 'device_id', value: deviceId);
  }

  return deviceId;
}