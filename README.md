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

## 道具

擦彈（絕妙度過子彈）每次 +1 點，可兌換道具（觸控按鈕或鍵盤 1–4）：

| 道具 | 點數 | 效果 |
|---|---|---|
| 護盾 | 8 | 擋下一次被擊中，之後 1 秒無敵 |
| 清屏 | 12 | 清除畫面上所有子彈 |
| 減速 | 5 | 子彈 40% 速度，持續 4 秒 |
| 縮小 | 5 | 機體縮小一半，持續 5 秒 |

參數在 `lib/util/item_type.dart`。

## 音效

`assets/audio/effect/*.wav` 由 `tool/gen_sfx.py` 合成（原創復古音色），
修改後重新產生：

```sh
python3 tool/gen_sfx.py assets/audio/effect
```

音量與同時播放數在 `lib/util/music_manager.dart` 的 `Sfx`。

## 遊戲參數

子彈速度、大小、發射間隔與誘導彈轉向參數集中在 `lib/util/bullet_level.dart`；
玩家移動速度為 `Training999.playerSpeed`（px/秒）。
