import 'package:flutter/material.dart';

import '../../domain/entities/alarm.dart';
import '../models/alarm_model.dart';

/// Alarm Entity 和 AlarmModel 之間的轉換器
class AlarmMapper {
  /// 從 Model 轉換為 Entity
  static Alarm toEntity(AlarmModel model) {
    return Alarm(
      id: model.id,
      time: TimeOfDay(hour: model.hour, minute: model.minute),
      isEnabled: model.isEnabled,
      repeatType: AlarmModel.indexToRepeatType(model.repeatTypeIndex),
      customDays: AlarmModel.indicesToDays(model.customDayIndices),
      label: model.label,
      ringtoneId: model.ringtoneId,
      newsCount: model.newsCount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// 從 Entity 轉換為 Model
  static AlarmModel toModel(Alarm entity) {
    return AlarmModel(
      id: entity.id,
      hour: entity.time.hour,
      minute: entity.time.minute,
      isEnabled: entity.isEnabled,
      repeatTypeIndex: AlarmModel.repeatTypeToIndex(entity.repeatType),
      customDayIndices: AlarmModel.daysToIndices(entity.customDays),
      label: entity.label,
      ringtoneId: entity.ringtoneId,
      newsCount: entity.newsCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
