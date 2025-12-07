import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'day_of_week.dart';
import 'repeat_type.dart';

/// 鬧鐘實體
class Alarm extends Equatable {
  /// 唯一識別碼
  final String id;

  /// 鬧鐘時間
  final TimeOfDay time;

  /// 是否啟用
  final bool isEnabled;

  /// 重複類型
  final RepeatType repeatType;

  /// 自訂重複日 (僅當 repeatType 為 custom 時使用)
  final Set<DayOfWeek>? customDays;

  /// 鬧鐘標籤
  final String label;

  /// 鈴聲 ID
  final String ringtoneId;

  /// 新聞數量
  final int newsCount;

  /// 建立時間
  final DateTime createdAt;

  /// 更新時間
  final DateTime updatedAt;

  const Alarm({
    required this.id,
    required this.time,
    required this.isEnabled,
    required this.repeatType,
    this.customDays,
    required this.label,
    required this.ringtoneId,
    required this.newsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 建立新鬧鐘的工廠方法
  factory Alarm.create({
    required String id,
    required TimeOfDay time,
    RepeatType repeatType = RepeatType.once,
    Set<DayOfWeek>? customDays,
    String label = '鬧鐘',
    String ringtoneId = 'default',
    int newsCount = 5,
  }) {
    final now = DateTime.now();
    return Alarm(
      id: id,
      time: time,
      isEnabled: true,
      repeatType: repeatType,
      customDays: customDays,
      label: label,
      ringtoneId: ringtoneId,
      newsCount: newsCount,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 複製並修改
  Alarm copyWith({
    String? id,
    TimeOfDay? time,
    bool? isEnabled,
    RepeatType? repeatType,
    Set<DayOfWeek>? customDays,
    String? label,
    String? ringtoneId,
    int? newsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
      repeatType: repeatType ?? this.repeatType,
      customDays: customDays ?? this.customDays,
      label: label ?? this.label,
      ringtoneId: ringtoneId ?? this.ringtoneId,
      newsCount: newsCount ?? this.newsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// 取得重複描述文字
  String get repeatDescription {
    switch (repeatType) {
      case RepeatType.once:
        return '只響一次';
      case RepeatType.daily:
        return '每日';
      case RepeatType.weekdays:
        return '週一至週五';
      case RepeatType.weekends:
        return '週六、日';
      case RepeatType.custom:
        if (customDays == null || customDays!.isEmpty) {
          return '未設定';
        }
        final sortedDays = customDays!.toList()
          ..sort((a, b) => a.weekdayValue.compareTo(b.weekdayValue));
        return sortedDays.map((d) => d.shortName).join('、');
    }
  }

  /// 取得時間格式化字串 (HH:mm)
  String get timeString {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  List<Object?> get props => [
        id,
        time.hour,
        time.minute,
        isEnabled,
        repeatType,
        customDays,
        label,
        ringtoneId,
        newsCount,
        createdAt,
        updatedAt,
      ];
}
