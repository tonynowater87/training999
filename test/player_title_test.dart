import 'package:flutter_test/flutter_test.dart';
import 'package:training999/util/player_title.dart';

void main() {
  test('titles are sorted and start at zero', () {
    expect(playerTitles.first.minSeconds, 0);
    for (var i = 1; i < playerTitles.length; i++) {
      expect(playerTitles[i].minSeconds,
          greaterThan(playerTitles[i - 1].minSeconds));
    }
  });

  test('picks the highest title reached', () {
    expect(titleFor(0).name, '秒殺體質');
    expect(titleFor(2999).name, '秒殺體質');
    expect(titleFor(3000).name, '剛拿到駕照');
    expect(titleFor(60000).name, '彈幕按摩師');
    expect(titleFor(9999999).name, playerTitles.last.name);
  });

  test('adds an epithet based on brilliant dodges', () {
    expect(fullTitleFor(10000, 0), '閃避見習生');
    expect(fullTitleFor(10000, 10), '大膽的 閃避見習生');
    expect(fullTitleFor(60000, 30), '玩命的 彈幕按摩師');
    expect(fullTitleFor(60000, 60), '擦彈中毒的 彈幕按摩師');
    expect(fullTitleFor(30000, 0), '優雅的 閃避達人');
  });
}
