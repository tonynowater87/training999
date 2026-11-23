# training999（特訓999）

一款以 Flutter + Flame 製作的橫向躲子彈遊戲，成績上傳至 Firebase Firestore 排行榜。

## 開發環境設定

1. 安裝 Flutter（Dart >= 3.6）。
2. 產生 Firebase 設定（`lib/firebase_options.dart`、`google-services.json`、`GoogleService-Info.plist` 皆已被 gitignore）：
   ```sh
   flutterfire configure
   ```
3. 安裝套件並產生程式碼（Riverpod / Freezed）：
   ```sh
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
4. 部署 Firestore 安全規則（`firestore.rules`）：
   ```sh
   firebase deploy --only firestore:rules
   ```
   或貼到 Firebase console > Firestore > Rules。

## 測試

```sh
flutter analyze
flutter test
```

## 遊戲參數

子彈速度、大小、發射間隔與誘導彈轉向參數集中在 `lib/util/bullet_level.dart`；
玩家移動速度為 `Training999.playerSpeed`（px/秒）。
