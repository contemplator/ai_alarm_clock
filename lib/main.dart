import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/alarm/data/models/alarm_model.dart';
import 'features/alarm/presentation/pages/alarm_list_page.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 註冊 Hive Type Adapters
  Hive.registerAdapter(AlarmModelAdapter());

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // 預設使用暗色主題
      home: const AlarmListPage(),
    );
  }
}
