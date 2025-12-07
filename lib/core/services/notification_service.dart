import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../../features/alarm/domain/entities/alarm.dart';
import '../../features/alarm/domain/entities/day_of_week.dart';
import '../../features/alarm/domain/entities/repeat_type.dart';

/// 通知服務
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// 初始化通知服務
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 初始化時區
    tz_data.initializeTimeZones();
    // 設定本地時區 (使用台灣時區)
    tz.setLocalLocation(tz.getLocation('Asia/Taipei'));

    // iOS 設定
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Android 設定 (備用)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      iOS: iosSettings,
      android: androidSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    debugPrint('NotificationService initialized with timezone: ${tz.local}');
  }

  /// 通知被點擊時的回調
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    if (response.payload != null) {
      // 延遲導航，確保 MaterialApp 已經準備好
      Future.delayed(const Duration(milliseconds: 100), () {
        _navigateToAlarmRinging(response.payload!);
      });
    }
  }

  /// 通知導航回調，由 main.dart 設定
  static void Function(String alarmId)? onAlarmTriggered;

  void _navigateToAlarmRinging(String alarmId) {
    if (onAlarmTriggered != null) {
      onAlarmTriggered!(alarmId);
    } else {
      debugPrint('Warning: onAlarmTriggered callback not set');
    }
  }

  /// 請求通知權限
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final bool? result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true;
  }

  /// 排程鬧鐘通知
  Future<void> scheduleAlarm(Alarm alarm) async {
    if (!alarm.isEnabled) {
      await cancelAlarm(alarm.id);
      return;
    }

    // 取消舊的通知
    await cancelAlarm(alarm.id);

    // 計算下次觸發時間
    final nextTriggerTimes = _calculateNextTriggerTimes(alarm);

    for (int i = 0; i < nextTriggerTimes.length; i++) {
      final triggerTime = nextTriggerTimes[i];
      final notificationId = _generateNotificationId(alarm.id, i);

      await _notifications.zonedSchedule(
        notificationId,
        '鬧鐘',
        alarm.label,
        triggerTime,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'default', // 使用預設音效
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
          android: AndroidNotificationDetails(
            'alarm_channel',
            '鬧鐘',
            channelDescription: '鬧鐘通知',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: _getDateTimeComponents(alarm.repeatType),
        payload: alarm.id,
      );

      debugPrint(
          'Scheduled alarm ${alarm.id} at ${triggerTime.toLocal()} (id: $notificationId)');
    }
  }

  /// 計算下次觸發時間
  List<tz.TZDateTime> _calculateNextTriggerTimes(Alarm alarm) {
    final now = tz.TZDateTime.now(tz.local);
    final List<tz.TZDateTime> times = [];

    switch (alarm.repeatType) {
      case RepeatType.once:
        times.add(_getNextOccurrence(now, alarm.time.hour, alarm.time.minute));
        break;

      case RepeatType.daily:
        times.add(_getNextOccurrence(now, alarm.time.hour, alarm.time.minute));
        break;

      case RepeatType.weekdays:
        // 排程週一到週五
        for (int weekday = 1; weekday <= 5; weekday++) {
          times.add(_getNextOccurrenceForWeekday(
              now, alarm.time.hour, alarm.time.minute, weekday));
        }
        break;

      case RepeatType.weekends:
        // 排程週六和週日
        for (int weekday in [6, 7]) {
          times.add(_getNextOccurrenceForWeekday(
              now, alarm.time.hour, alarm.time.minute, weekday));
        }
        break;

      case RepeatType.custom:
        if (alarm.customDays != null) {
          for (final day in alarm.customDays!) {
            times.add(_getNextOccurrenceForWeekday(
                now, alarm.time.hour, alarm.time.minute, day.weekdayValue));
          }
        }
        break;
    }

    return times;
  }

  /// 取得下次發生時間
  tz.TZDateTime _getNextOccurrence(tz.TZDateTime now, int hour, int minute) {
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // 如果時間已過，設為明天
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// 取得特定星期幾的下次發生時間
  tz.TZDateTime _getNextOccurrenceForWeekday(
      tz.TZDateTime now, int hour, int minute, int weekday) {
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // 計算到目標星期幾的天數差
    int daysUntil = weekday - now.weekday;
    if (daysUntil < 0) {
      daysUntil += 7;
    } else if (daysUntil == 0 && scheduled.isBefore(now)) {
      daysUntil = 7;
    }

    scheduled = scheduled.add(Duration(days: daysUntil));
    return scheduled;
  }

  /// 取得日期時間匹配組件
  DateTimeComponents? _getDateTimeComponents(RepeatType repeatType) {
    switch (repeatType) {
      case RepeatType.once:
        return null; // 單次不重複
      case RepeatType.daily:
        return DateTimeComponents.time; // 每天同一時間
      case RepeatType.weekdays:
      case RepeatType.weekends:
      case RepeatType.custom:
        return DateTimeComponents.dayOfWeekAndTime; // 每週同一時間
    }
  }

  /// 生成通知 ID
  int _generateNotificationId(String alarmId, int index) {
    return alarmId.hashCode + index;
  }

  /// 取消鬧鐘通知
  Future<void> cancelAlarm(String alarmId) async {
    // 取消所有可能的通知 (最多 7 個，對應一週七天)
    for (int i = 0; i < 7; i++) {
      final notificationId = _generateNotificationId(alarmId, i);
      await _notifications.cancel(notificationId);
    }
    debugPrint('Cancelled alarm notifications for $alarmId');
  }

  /// 取消所有通知
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    debugPrint('Cancelled all notifications');
  }

  /// 取得所有待處理的通知
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}

/// NotificationService Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
