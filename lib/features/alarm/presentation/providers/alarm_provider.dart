import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/alarm_local_datasource.dart';
import '../../data/repositories/alarm_repository_impl.dart';
import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';

/// UUID 生成器 Provider
final uuidProvider = Provider<Uuid>((ref) => const Uuid());

/// AlarmLocalDataSource Provider
final alarmLocalDataSourceProvider = Provider<AlarmLocalDataSource>((ref) {
  return AlarmLocalDataSource();
});

/// AlarmRepository Provider
final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepositoryImpl(
    localDataSource: ref.watch(alarmLocalDataSourceProvider),
  );
});

/// 鬧鐘列表狀態
class AlarmListState {
  final List<Alarm> alarms;
  final bool isLoading;
  final String? errorMessage;

  const AlarmListState({
    this.alarms = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AlarmListState copyWith({
    List<Alarm>? alarms,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AlarmListState(
      alarms: alarms ?? this.alarms,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// 鬧鐘列表 Notifier
class AlarmListNotifier extends StateNotifier<AlarmListState> {
  final AlarmRepository _repository;
  final Uuid _uuid;

  AlarmListNotifier({
    required AlarmRepository repository,
    required Uuid uuid,
  })  : _repository = repository,
        _uuid = uuid,
        super(const AlarmListState(isLoading: true)) {
    loadAlarms();
  }

  /// 載入所有鬧鐘
  Future<void> loadAlarms() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final alarms = await _repository.getAlarms();
      state = state.copyWith(alarms: alarms, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '載入鬧鐘失敗: $e',
      );
    }
  }

  /// 新增鬧鐘
  Future<void> addAlarm(Alarm alarm) async {
    try {
      final newAlarm = alarm.copyWith(id: _uuid.v4());
      await _repository.createAlarm(newAlarm);
      await loadAlarms();
    } catch (e) {
      state = state.copyWith(errorMessage: '新增鬧鐘失敗: $e');
    }
  }

  /// 更新鬧鐘
  Future<void> updateAlarm(Alarm alarm) async {
    try {
      await _repository.updateAlarm(alarm);
      await loadAlarms();
    } catch (e) {
      state = state.copyWith(errorMessage: '更新鬧鐘失敗: $e');
    }
  }

  /// 刪除鬧鐘
  Future<void> deleteAlarm(String id) async {
    try {
      await _repository.deleteAlarm(id);
      await loadAlarms();
    } catch (e) {
      state = state.copyWith(errorMessage: '刪除鬧鐘失敗: $e');
    }
  }

  /// 切換鬧鐘啟用狀態
  Future<void> toggleAlarm(String id, bool isEnabled) async {
    try {
      await _repository.toggleAlarm(id, isEnabled);
      // 直接更新 state 以獲得更即時的 UI 回應
      state = state.copyWith(
        alarms: state.alarms.map((a) {
          if (a.id == id) {
            return a.copyWith(isEnabled: isEnabled);
          }
          return a;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: '切換鬧鐘失敗: $e');
      await loadAlarms(); // 發生錯誤時重新載入
    }
  }
}

/// AlarmListNotifier Provider
final alarmListProvider =
    StateNotifierProvider<AlarmListNotifier, AlarmListState>((ref) {
  return AlarmListNotifier(
    repository: ref.watch(alarmRepositoryProvider),
    uuid: ref.watch(uuidProvider),
  );
});
