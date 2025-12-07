/// 一週中的日子
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension DayOfWeekExtension on DayOfWeek {
  /// 取得縮寫顯示文字
  String get shortName {
    switch (this) {
      case DayOfWeek.monday:
        return '一';
      case DayOfWeek.tuesday:
        return '二';
      case DayOfWeek.wednesday:
        return '三';
      case DayOfWeek.thursday:
        return '四';
      case DayOfWeek.friday:
        return '五';
      case DayOfWeek.saturday:
        return '六';
      case DayOfWeek.sunday:
        return '日';
    }
  }

  /// 取得完整顯示文字
  String get fullName {
    switch (this) {
      case DayOfWeek.monday:
        return '週一';
      case DayOfWeek.tuesday:
        return '週二';
      case DayOfWeek.wednesday:
        return '週三';
      case DayOfWeek.thursday:
        return '週四';
      case DayOfWeek.friday:
        return '週五';
      case DayOfWeek.saturday:
        return '週六';
      case DayOfWeek.sunday:
        return '週日';
    }
  }

  /// 轉換為 DateTime.weekday 的值 (1 = Monday, 7 = Sunday)
  int get weekdayValue {
    switch (this) {
      case DayOfWeek.monday:
        return 1;
      case DayOfWeek.tuesday:
        return 2;
      case DayOfWeek.wednesday:
        return 3;
      case DayOfWeek.thursday:
        return 4;
      case DayOfWeek.friday:
        return 5;
      case DayOfWeek.saturday:
        return 6;
      case DayOfWeek.sunday:
        return 7;
    }
  }
}
