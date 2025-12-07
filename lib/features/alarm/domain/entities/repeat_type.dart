/// 鬧鐘重複類型
enum RepeatType {
  /// 單次
  once,

  /// 每日
  daily,

  /// 工作日 (週一至週五)
  weekdays,

  /// 週末 (週六、日)
  weekends,

  /// 自訂
  custom,
}

/// 取得重複類型的顯示文字
extension RepeatTypeExtension on RepeatType {
  String get displayName {
    switch (this) {
      case RepeatType.once:
        return '只響一次';
      case RepeatType.daily:
        return '每日';
      case RepeatType.weekdays:
        return '工作日';
      case RepeatType.weekends:
        return '週末';
      case RepeatType.custom:
        return '自訂';
    }
  }
}
