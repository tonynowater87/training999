/// Titles awarded by survive time, with an optional epithet based on how many
/// bullets were brilliantly dodged (near misses).
class PlayerTitle {
  const PlayerTitle(this.minSeconds, this.name);

  /// Minimum survive time (seconds) to earn this title.
  final int minSeconds;
  final String name;
}

/// Ordered from lowest to highest. The first entry must start at 0.
const List<PlayerTitle> playerTitles = [
  PlayerTitle(0, '秒殺體質'),
  PlayerTitle(3, '剛拿到駕照'),
  PlayerTitle(6, '新手上路'),
  PlayerTitle(10, '閃避見習生'),
  PlayerTitle(15, '還算可以'),
  PlayerTitle(20, '有點東西'),
  PlayerTitle(25, '彈幕觀光客'),
  PlayerTitle(30, '閃避達人'),
  PlayerTitle(40, '人形自走迴避器'),
  PlayerTitle(50, '子彈都繞著你走'),
  PlayerTitle(60, '彈幕按摩師'),
  PlayerTitle(75, '擦彈藝術家'),
  PlayerTitle(90, '傳說中的王牌'),
  PlayerTitle(105, '已經不是人類'),
  PlayerTitle(120, '彈幕之神'),
  PlayerTitle(150, '特訓999畢業生'),
  PlayerTitle(180, '請收下我的膝蓋'),
];

/// Index into [playerTitles] for the given survive time.
int titleIndexFor(int surviveTimeInMilliseconds) {
  final seconds = surviveTimeInMilliseconds / 1000;
  var index = 0;
  for (var i = 0; i < playerTitles.length; i++) {
    if (seconds >= playerTitles[i].minSeconds) {
      index = i;
    }
  }
  return index;
}

PlayerTitle titleFor(int surviveTimeInMilliseconds) =>
    playerTitles[titleIndexFor(surviveTimeInMilliseconds)];

/// Epithet describing the play style, or null when nothing stands out.
String? epithetFor(int surviveTimeInMilliseconds, int brilliantlyDodged) {
  if (brilliantlyDodged >= 60) {
    return '擦彈中毒的';
  }
  if (brilliantlyDodged >= 30) {
    return '玩命的';
  }
  if (brilliantlyDodged >= 10) {
    return '大膽的';
  }
  if (brilliantlyDodged == 0 && surviveTimeInMilliseconds >= 30000) {
    return '優雅的';
  }
  return null;
}

/// Full title, e.g. "玩命的 彈幕按摩師".
String fullTitleFor(int surviveTimeInMilliseconds, int brilliantlyDodged) {
  final title = titleFor(surviveTimeInMilliseconds).name;
  final epithet = epithetFor(surviveTimeInMilliseconds, brilliantlyDodged);
  return epithet == null ? title : '$epithet $title';
}
