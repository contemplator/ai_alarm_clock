import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/alarm.dart';
import '../../../../shared/theme/app_theme.dart';

/// 鬧鐘卡片 Widget
class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = alarm.isEnabled;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // 左側：時間與描述
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 時間
                  Text(
                    alarm.timeString,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: isEnabled
                          ? AppColors.textPrimaryDark
                          : AppColors.textSecondaryDark,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 標籤
                  Text(
                    alarm.label,
                    style: TextStyle(
                      fontSize: 15,
                      color: isEnabled
                          ? AppColors.textPrimaryDark
                          : AppColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // 重複描述
                  Text(
                    alarm.repeatDescription,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            // 右側：開關
            CupertinoSwitch(
              value: alarm.isEnabled,
              onChanged: onToggle,
              activeTrackColor: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
}
