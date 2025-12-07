import '../entities/alarm.dart';

/// 鬧鐘 Repository 抽象介面
abstract class AlarmRepository {
  /// 取得所有鬧鐘
  Future<List<Alarm>> getAlarms();

  /// 根據 ID 取得鬧鐘
  Future<Alarm?> getAlarmById(String id);

  /// 建立新鬧鐘
  Future<void> createAlarm(Alarm alarm);

  /// 更新鬧鐘
  Future<void> updateAlarm(Alarm alarm);

  /// 刪除鬧鐘
  Future<void> deleteAlarm(String id);

  /// 切換鬧鐘啟用狀態
  Future<void> toggleAlarm(String id, bool isEnabled);
}
