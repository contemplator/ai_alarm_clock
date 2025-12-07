import 'package:hive/hive.dart';

import '../../domain/entities/day_of_week.dart';
import '../../domain/entities/repeat_type.dart';

part 'alarm_model.g.dart';

/// 鬧鐘資料模型 (用於 Hive 儲存)
@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int hour;

  @HiveField(2)
  final int minute;

  @HiveField(3)
  final bool isEnabled;

  @HiveField(4)
  final int repeatTypeIndex;

  @HiveField(5)
  final List<int>? customDayIndices;

  @HiveField(6)
  final String label;

  @HiveField(7)
  final String ringtoneId;

  @HiveField(8)
  final int newsCount;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    required this.isEnabled,
    required this.repeatTypeIndex,
    this.customDayIndices,
    required this.label,
    required this.ringtoneId,
    required this.newsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 將 RepeatType 轉換為索引
  static int repeatTypeToIndex(RepeatType type) {
    return type.index;
  }

  /// 將索引轉換為 RepeatType
  static RepeatType indexToRepeatType(int index) {
    return RepeatType.values[index];
  }

  /// 將 DayOfWeek Set 轉換為索引列表
  static List<int>? daysToIndices(Set<DayOfWeek>? days) {
    if (days == null) return null;
    return days.map((d) => d.index).toList();
  }

  /// 將索引列表轉換為 DayOfWeek Set
  static Set<DayOfWeek>? indicesToDays(List<int>? indices) {
    if (indices == null) return null;
    return indices.map((i) => DayOfWeek.values[i]).toSet();
  }
}
