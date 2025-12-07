import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/alarm.dart';
import '../../domain/entities/repeat_type.dart';
import '../../../../shared/theme/app_theme.dart';

/// 鬧鐘編輯頁面
class AlarmEditPage extends StatefulWidget {
  final Alarm? alarm; // null 表示新增模式

  const AlarmEditPage({super.key, this.alarm});

  @override
  State<AlarmEditPage> createState() => _AlarmEditPageState();
}

class _AlarmEditPageState extends State<AlarmEditPage> {
  late TimeOfDay _selectedTime;
  late RepeatType _selectedRepeatType;
  late String _label;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.alarm != null;
    if (_isEditing) {
      _selectedTime = widget.alarm!.time;
      _selectedRepeatType = widget.alarm!.repeatType;
      _label = widget.alarm!.label;
    } else {
      _selectedTime = TimeOfDay.now();
      _selectedRepeatType = RepeatType.once;
      _label = '鬧鐘';
    }
  }

  void _handleSave() {
    final now = DateTime.now();
    Alarm resultAlarm;

    if (_isEditing) {
      resultAlarm = widget.alarm!.copyWith(
        time: _selectedTime,
        repeatType: _selectedRepeatType,
        label: _label,
        updatedAt: now,
      );
    } else {
      resultAlarm = Alarm.create(
        id: '', // 將由 provider 生成
        time: _selectedTime,
        repeatType: _selectedRepeatType,
        label: _label,
      );
    }

    Navigator.of(context).pop(resultAlarm);
  }

  void _handleDelete() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('刪除鬧鐘'),
        content: const Text('確定要刪除這個鬧鐘嗎？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('刪除'),
            onPressed: () {
              Navigator.of(context).pop(); // 關閉對話框
              Navigator.of(context).pop({'delete': widget.alarm!.id}); // 返回刪除指令
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text(
            '取消',
            style: TextStyle(color: AppColors.primaryDark),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_isEditing ? '編輯鬧鐘' : '新增鬧鐘'),
        actions: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: _handleSave,
            child: const Text(
              '儲存',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // 時間選擇器
          SizedBox(
            height: 216,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                brightness: Brightness.dark,
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  2024,
                  1,
                  1,
                  _selectedTime.hour,
                  _selectedTime.minute,
                ),
                use24hFormat: true,
                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    _selectedTime = TimeOfDay(
                      hour: dateTime.hour,
                      minute: dateTime.minute,
                    );
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 設定區塊
          _buildSectionHeader('重複'),
          _buildSettingsCard([
            _buildRepeatOption(RepeatType.once),
            _buildRepeatOption(RepeatType.daily),
            _buildRepeatOption(RepeatType.weekdays),
            _buildRepeatOption(RepeatType.weekends),
          ]),

          const SizedBox(height: 24),

          _buildSectionHeader('標籤'),
          _buildSettingsCard([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CupertinoTextField(
                controller: TextEditingController(text: _label),
                placeholder: '鬧鐘標籤',
                style: const TextStyle(color: AppColors.textPrimaryDark),
                decoration: null,
                onChanged: (value) {
                  _label = value;
                },
              ),
            ),
          ]),

          // 刪除按鈕 (僅編輯模式)
          if (_isEditing) ...[
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoButton(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                onPressed: _handleDelete,
                child: const Text(
                  '刪除鬧鐘',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondaryDark,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index < children.length - 1)
                const Divider(
                  height: 1,
                  indent: 16,
                  color: AppColors.backgroundDark,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRepeatOption(RepeatType type) {
    final isSelected = _selectedRepeatType == type;
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: () {
        setState(() {
          _selectedRepeatType = type;
        });
      },
      child: Row(
        children: [
          Text(
            type.displayName,
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.textPrimaryDark,
            ),
          ),
          const Spacer(),
          if (isSelected)
            const Icon(
              CupertinoIcons.checkmark,
              color: AppColors.primaryDark,
              size: 20,
            ),
        ],
      ),
    );
  }
}
