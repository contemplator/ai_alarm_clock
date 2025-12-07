import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/alarm_provider.dart';
import '../widgets/alarm_card.dart';
import '../../../../shared/theme/app_theme.dart';
import 'alarm_edit_page.dart';

/// 鬧鐘列表頁面 (首頁)
class AlarmListPage extends ConsumerWidget {
  const AlarmListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alarmListProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.settings),
          onPressed: () {
            // TODO: 導航到設定頁面
          },
        ),
        title: const Text('鬧鐘'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: () => _navigateToAddAlarm(context, ref),
          ),
        ],
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AlarmListState state,
  ) {
    if (state.isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_circle,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.errorMessage!,
              style: const TextStyle(color: AppColors.textSecondaryDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              child: const Text('重試'),
              onPressed: () {
                ref.read(alarmListProvider.notifier).loadAlarms();
              },
            ),
          ],
        ),
      );
    }

    if (state.alarms.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.alarms.length,
      itemBuilder: (context, index) {
        final alarm = state.alarms[index];
        return AlarmCard(
          alarm: alarm,
          onTap: () => _navigateToEditAlarm(context, ref, alarm),
          onToggle: (isEnabled) {
            ref.read(alarmListProvider.notifier).toggleAlarm(
                  alarm.id,
                  isEnabled,
                );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.alarm,
            size: 80,
            color: AppColors.textSecondaryDark.withAlpha(128),
          ),
          const SizedBox(height: 24),
          const Text(
            '尚未設定鬧鐘',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '點擊右上角 + 新增鬧鐘',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 32),
          CupertinoButton.filled(
            onPressed: () => _navigateToAddAlarm(context, ref),
            child: const Text('新增鬧鐘'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddAlarm(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const AlarmEditPage(),
      ),
    );

    if (result != null && result is Map && result.containsKey('delete')) {
      // 不應該發生在新增模式
    } else if (result != null) {
      ref.read(alarmListProvider.notifier).addAlarm(result);
    }
  }

  Future<void> _navigateToEditAlarm(
    BuildContext context,
    WidgetRef ref,
    dynamic alarm,
  ) async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => AlarmEditPage(alarm: alarm),
      ),
    );

    if (result != null && result is Map && result.containsKey('delete')) {
      ref.read(alarmListProvider.notifier).deleteAlarm(result['delete']);
    } else if (result != null) {
      ref.read(alarmListProvider.notifier).updateAlarm(result);
    }
  }
}
