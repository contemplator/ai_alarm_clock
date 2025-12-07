import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../datasources/alarm_local_datasource.dart';
import '../mappers/alarm_mapper.dart';

/// AlarmRepository 的具體實作
class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmLocalDataSource _localDataSource;

  AlarmRepositoryImpl({required AlarmLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<Alarm>> getAlarms() async {
    final models = await _localDataSource.getAlarms();
    final alarms = models.map((m) => AlarmMapper.toEntity(m)).toList();
    // 按時間排序
    alarms.sort((a, b) {
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return alarms;
  }

  @override
  Future<Alarm?> getAlarmById(String id) async {
    final model = await _localDataSource.getAlarmById(id);
    if (model == null) return null;
    return AlarmMapper.toEntity(model);
  }

  @override
  Future<void> createAlarm(Alarm alarm) async {
    final model = AlarmMapper.toModel(alarm);
    await _localDataSource.saveAlarm(model);
  }

  @override
  Future<void> updateAlarm(Alarm alarm) async {
    final model = AlarmMapper.toModel(alarm);
    await _localDataSource.saveAlarm(model);
  }

  @override
  Future<void> deleteAlarm(String id) async {
    await _localDataSource.deleteAlarm(id);
  }

  @override
  Future<void> toggleAlarm(String id, bool isEnabled) async {
    final alarm = await getAlarmById(id);
    if (alarm != null) {
      final updatedAlarm = alarm.copyWith(isEnabled: isEnabled);
      await updateAlarm(updatedAlarm);
    }
  }
}
