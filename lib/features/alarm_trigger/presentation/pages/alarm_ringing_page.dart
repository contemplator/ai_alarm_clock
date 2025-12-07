import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../alarm/domain/entities/alarm.dart';

/// 鬧鐘響起狀態
enum AlarmRingingState {
  /// 播放鬧鈴中
  ringing,

  /// 播放新聞中
  broadcasting,

  /// 已停止
  stopped,
}

/// 鬧鐘響起頁面
class AlarmRingingPage extends StatefulWidget {
  final Alarm? alarm;
  final String? alarmId;

  const AlarmRingingPage({
    super.key,
    this.alarm,
    this.alarmId,
  });

  @override
  State<AlarmRingingPage> createState() => _AlarmRingingPageState();
}

class _AlarmRingingPageState extends State<AlarmRingingPage>
    with SingleTickerProviderStateMixin {
  AlarmRingingState _state = AlarmRingingState.ringing;
  int _countdownSeconds = 15;
  Timer? _countdownTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // 設定脈動動畫
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 開始倒數計時
    _startCountdown();

    // 觸發震動回饋
    HapticFeedback.heavyImpact();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        timer.cancel();
        _startBroadcasting();
      }
    });
  }

  void _startBroadcasting() {
    setState(() {
      _state = AlarmRingingState.broadcasting;
    });
    // TODO: 開始 TTS 播報新聞
  }

  void _handleStop() {
    _countdownTimer?.cancel();
    setState(() {
      _state = AlarmRingingState.stopped;
    });

    // 震動回饋
    HapticFeedback.mediumImpact();

    // 返回首頁
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundDark,
                AppColors.primaryDark.withAlpha(30),
                AppColors.backgroundDark,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // 時間顯示
              _buildTimeDisplay(),

              const SizedBox(height: 16),

              // 標籤
              Text(
                widget.alarm?.label ?? '鬧鐘',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryDark,
                ),
              ),

              const SizedBox(height: 8),

              // 重複描述
              Text(
                widget.alarm?.repeatDescription ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondaryDark,
                ),
              ),

              const Spacer(),

              // 狀態區域
              _buildStatusCard(),

              const Spacer(),

              // 停止按鈕
              _buildStopButton(),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final timeString = widget.alarm?.timeString ?? _getCurrentTimeString();

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Text(
            timeString,
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w200,
              color: AppColors.textPrimaryDark,
              letterSpacing: -2,
            ),
          ),
        );
      },
    );
  }

  String _getCurrentTimeString() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildStatusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withAlpha(200),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryDark.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 狀態圖示
          Icon(
            _state == AlarmRingingState.ringing
                ? CupertinoIcons.bell_fill
                : CupertinoIcons.doc_text_fill,
            size: 32,
            color: _state == AlarmRingingState.ringing
                ? AppColors.warning
                : AppColors.primaryDark,
          ),

          const SizedBox(height: 12),

          // 狀態文字
          Text(
            _getStateText(),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryDark,
            ),
          ),

          const SizedBox(height: 8),

          // 附加資訊
          Text(
            _getStateDescription(),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStateText() {
    switch (_state) {
      case AlarmRingingState.ringing:
        return '🔔 鬧鈴播放中';
      case AlarmRingingState.broadcasting:
        return '📰 新聞播報中';
      case AlarmRingingState.stopped:
        return '已停止';
    }
  }

  String _getStateDescription() {
    switch (_state) {
      case AlarmRingingState.ringing:
        return '$_countdownSeconds 秒後開始播報新聞';
      case AlarmRingingState.broadcasting:
        return '正在播放今日新聞摘要...';
      case AlarmRingingState.stopped:
        return '';
    }
  }

  Widget _buildStopButton() {
    return GestureDetector(
      onTap: _handleStop,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primaryDark.withAlpha(180),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withAlpha(80),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '停止',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
