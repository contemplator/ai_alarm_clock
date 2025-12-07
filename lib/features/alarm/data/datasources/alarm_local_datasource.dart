import 'package:hive/hive.dart';

import '../models/alarm_model.dart';

/// 鬧鐘本地資料來源
class AlarmLocalDataSource {
  static const String _boxName = 'alarms';

  /// 取得 Hive Box
  Future<Box<AlarmModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<AlarmModel>(_boxName);
    }
    return Hive.box<AlarmModel>(_boxName);
  }

  /// 取得所有鬧鐘
  Future<List<AlarmModel>> getAlarms() async {
    final box = await _getBox();
    return box.values.toList();
  }

  /// 根據 ID 取得鬧鐘
  Future<AlarmModel?> getAlarmById(String id) async {
    final box = await _getBox();
    return box.get(id);
  }

  /// 儲存鬧鐘
  Future<void> saveAlarm(AlarmModel alarm) async {
    final box = await _getBox();
    await box.put(alarm.id, alarm);
  }

  /// 刪除鬧鐘
  Future<void> deleteAlarm(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  /// 取得鬧鐘數量
  Future<int> getAlarmCount() async {
    final box = await _getBox();
    return box.length;
  }
}
