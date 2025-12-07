import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/notification_service.dart';
import 'features/alarm/data/models/alarm_model.dart';
import 'features/alarm/presentation/pages/alarm_list_page.dart';
import 'features/alarm_trigger/presentation/pages/alarm_ringing_page.dart';
import 'shared/theme/app_theme.dart';

/// 全域 Navigator Key，用於從任何地方導航
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 註冊 Hive Type Adapters
  Hive.registerAdapter(AlarmModelAdapter());

  // 設定通知導航回調
  NotificationService.onAlarmTriggered = (alarmId) {
    navigateToAlarmRinging(alarmId);
  };

  runApp(
    const ProviderScope(
      child: AIAlarmClockApp(),
    ),
  );
}

class AIAlarmClockApp extends StatelessWidget {
  const AIAlarmClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 新聞鬧鐘',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const AlarmListPage(),
      onGenerateRoute: (settings) {
        // 處理通知導航
        if (settings.name == '/alarm-ringing') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AlarmRingingPage(
              alarmId: args?['alarmId'],
            ),
          );
        }
        return null;
      },
    );
  }
}

/// 導航到鬧鐘響起頁面
void navigateToAlarmRinging(String alarmId) {
  navigatorKey.currentState?.pushNamed(
    '/alarm-ringing',
    arguments: {'alarmId': alarmId},
  );
}
