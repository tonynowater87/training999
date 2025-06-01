import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';

// 假設 Training999 是你的遊戲類別，繼承自 FlameGame
// import 'path/to/your/training_999.dart'; // 請確認此路徑正確

class InfoTextComponent extends TextComponent
    with HasGameRef<Training999> { // <<-- 這裡沒有 HasOpacityProvider 或 HasOpacity
  // 儲存原始文字顏色，因為我們需要不斷更新它的透明度
  final Color _originalTextColor;

  // 記錄淡出過程的狀態
  double _currentOpacity = 1.0; // 目前的透明度，從完全不透明開始
  double _fadeDuration = 1.0;  // 淡出總時長 (秒)
  double _elapsedTime = 0.0;   // 已經經過的時間
  bool _isFading = false;      // 是否正在淡出中

  // 在建構子中直接初始化 TextPaint，確保其類型為 TextPaint
  InfoTextComponent(String text, Vector2 position)
      : _originalTextColor = Colors.white, // 設定初始文字顏色 (例如白色)
        super(
        position: position,
        text: text,
        // 直接將 textRenderer 設為 TextPaint 實例
        textRenderer: TextPaint(
            style: const TextStyle(color: Colors.white, fontSize: 24)),
      );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.topCenter;

    // 啟動時確保文字是完全不透明的。
    // 這裡我們直接修改當前的 TextPaint 實例的 color。
    // 但 TextPaint 本身是 immutable 的，所以正確做法是重新賦值。
    // 在 onLoad 裡，我們只需要確保起始狀態正確。
    // update 函數會處理後續的動態變化。

    // 開始淡出
    startFadeOut(duration: 1.0); // 淡出時長為 1 秒
  }

  // 呼叫此方法開始淡出效果
  void startFadeOut({double duration = 1.0}) {
    _fadeDuration = duration;
    _elapsedTime = 0.0;
    _currentOpacity = 1.0; // 確保從完全不透明開始淡出
    _isFading = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isFading) {
      _elapsedTime += dt; // 累加經過的時間

      // 計算新的透明度
      if (_elapsedTime >= _fadeDuration) {
        _currentOpacity = 0.0; // 確保淡出完成時透明度為 0
        _isFading = false;     // 停止淡出
        removeFromParent();    // 淡出完成後移除組件
      } else {
        // 線性計算透明度：從 1.0 遞減到 0.0
        _currentOpacity = 1.0 - (_elapsedTime / _fadeDuration);
      }

      // 關鍵修正：
      // 由於 `textRenderer` 是 `TextRenderer` 類型，我們需要先將它向下轉型為 `TextPaint`
      // 才能訪問 `style` 屬性。或者，更安全地，重新創建一個新的 `TextPaint` 實例。
      // 因為 TextPaint 是不可變的，每次改變都需要創建一個新的實例。
      textRenderer = TextPaint(
        style: TextStyle(
          color: _originalTextColor.withOpacity(_currentOpacity),
          fontSize: (textRenderer as TextPaint).style.fontSize, // 保留原始字體大小
          fontFamily: (textRenderer as TextPaint).style.fontFamily, // 保留字體
          fontWeight: (textRenderer as TextPaint).style.fontWeight, // 保留字體粗細
          // ... 其他你可能需要保留的 TextStyle 屬性
        ),
      );
    }
  }
}