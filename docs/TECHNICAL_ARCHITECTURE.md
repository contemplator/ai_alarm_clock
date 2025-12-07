# AI 新聞鬧鐘 App - 技術架構文件

> **版本**: 1.0.0  
> **最後更新**: 2025-12-07  
> **狀態**: 草稿

---

## 1. 技術棧總覽

| 層級            | 技術選擇                    | 說明                       |
| --------------- | --------------------------- | -------------------------- |
| **框架**        | Flutter 3.x                 | 跨平台開發框架             |
| **語言**        | Dart                        | Flutter 主要語言           |
| **目標平台**    | iOS 15.0+                   | iPhone 專用                |
| **狀態管理**    | Riverpod 2.x                | 現代化、類型安全的狀態管理 |
| **本地儲存**    | Hive / SharedPreferences    | 輕量級 NoSQL 儲存          |
| **HTTP 客戶端** | Dio                         | 功能完整的 HTTP 庫         |
| **AI 服務**     | Google Gemini API           | 新聞摘要生成               |
| **TTS**         | iOS AVSpeechSynthesizer     | 系統內建語音合成           |
| **通知**        | flutter_local_notifications | 本地推播通知               |
| **音訊**        | audioplayers / just_audio   | 鬧鈴播放                   |

---

## 2. 專案結構

```
lib/
├── main.dart                      # App 入口點
├── app.dart                       # App 配置 & 路由
│
├── core/                          # 核心基礎設施
│   ├── constants/                 # 常數定義
│   │   ├── app_constants.dart     # App 全域常數
│   │   ├── api_constants.dart     # API 相關常數
│   │   └── storage_keys.dart      # 儲存 Key 常數
│   │
│   ├── errors/                    # 錯誤處理
│   │   ├── exceptions.dart        # 自定義例外
│   │   └── failures.dart          # 失敗類型定義
│   │
│   ├── network/                   # 網路層
│   │   ├── dio_client.dart        # Dio HTTP 客戶端
│   │   └── network_info.dart      # 網路狀態檢查
│   │
│   ├── services/                  # 核心服務
│   │   ├── notification_service.dart  # 推播通知服務
│   │   ├── audio_service.dart     # 音訊播放服務
│   │   ├── tts_service.dart       # TTS 語音服務
│   │   └── storage_service.dart   # 本地儲存服務
│   │
│   └── utils/                     # 工具函數
│       ├── date_utils.dart        # 日期處理
│       └── logger.dart            # 日誌工具
│
├── features/                      # 功能模組 (按功能分層)
│   │
│   ├── alarm/                     # 鬧鐘功能
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── alarm_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── alarm_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── alarm_local_datasource.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── alarm.dart
│   │   │   ├── repositories/
│   │   │   │   └── alarm_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_alarm.dart
│   │   │       ├── update_alarm.dart
│   │   │       ├── delete_alarm.dart
│   │   │       ├── get_alarms.dart
│   │   │       └── toggle_alarm.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── alarm_provider.dart
│   │       ├── pages/
│   │       │   ├── alarm_list_page.dart
│   │       │   └── alarm_edit_page.dart
│   │       └── widgets/
│   │           ├── alarm_card.dart
│   │           ├── time_picker.dart
│   │           └── repeat_selector.dart
│   │
│   ├── news/                      # 新聞功能
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── news_item_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── news_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── rss_datasource.dart        # RSS 獲取
│   │   │       └── ai_summary_datasource.dart # AI 摘要
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── news_item.dart
│   │   │   ├── repositories/
│   │   │   │   └── news_repository.dart
│   │   │   └── usecases/
│   │   │       ├── fetch_news.dart
│   │   │       └── summarize_news.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── news_provider.dart
│   │       └── widgets/
│   │           └── news_preview_card.dart
│   │
│   ├── alarm_trigger/              # 鬧鐘觸發 & 播報
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── alarm_trigger_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── trigger_alarm.dart
│   │   │       ├── play_ringtone.dart
│   │   │       ├── broadcast_news.dart
│   │   │       └── stop_alarm.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── alarm_trigger_provider.dart
│   │       └── pages/
│   │           └── alarm_ringing_page.dart    # 鬧鐘響起全螢幕頁面
│   │
│   └── settings/                   # 設定功能
│       ├── data/
│       │   └── repositories/
│       │       └── settings_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── app_settings.dart
│       │   └── usecases/
│       │       ├── get_settings.dart
│       │       └── update_settings.dart
│       │
│       └── presentation/
│           ├── providers/
│           │   └── settings_provider.dart
│           └── pages/
│               ├── settings_page.dart
│               ├── news_source_settings_page.dart
│               └── ringtone_settings_page.dart
│
├── shared/                         # 共享元件
│   ├── widgets/                    # 共用 Widget
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   └── loading_indicator.dart
│   │
│   └── theme/                      # 主題設定
│       ├── app_theme.dart
│       ├── app_colors.dart
│       └── app_text_styles.dart
│
└── l10n/                           # 國際化 (可選)
    ├── app_en.arb
    └── app_zh.arb
```

---

## 3. 架構設計

### 3.1 Clean Architecture 分層

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────┐  ┌──────────┐  ┌────────────────────────────┐ │
│  │  Pages  │  │ Widgets  │  │  Providers (Riverpod)      │ │
│  └────┬────┘  └────┬─────┘  └─────────────┬──────────────┘ │
│       │            │                       │                 │
├───────┼────────────┼───────────────────────┼─────────────────┤
│       │            │    Domain Layer       │                 │
│       │      ┌─────┴───────┐        ┌──────┴─────┐          │
│       │      │  Use Cases  │        │  Entities  │          │
│       │      └──────┬──────┘        └────────────┘          │
│       │             │                                        │
│       │      ┌──────┴──────────┐                            │
│       │      │  Repositories   │  (Abstract)                │
│       │      └──────┬──────────┘                            │
├───────┼─────────────┼────────────────────────────────────────┤
│       │             │     Data Layer                         │
│       │      ┌──────┴──────────┐                            │
│       │      │  Repositories   │  (Implementation)          │
│       │      └──────┬──────────┘                            │
│       │             │                                        │
│       │      ┌──────┴──────────┐   ┌─────────────────┐      │
│       │      │  Data Sources   │   │     Models      │      │
│       │      │  (Local/Remote) │   │  (JSON/Hive)    │      │
│       │      └─────────────────┘   └─────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 狀態管理 (Riverpod)

```dart
// 範例：鬧鐘列表 Provider
@riverpod
class AlarmList extends _$AlarmList {
  @override
  Future<List<Alarm>> build() async {
    final repository = ref.watch(alarmRepositoryProvider);
    return repository.getAlarms();
  }

  Future<void> addAlarm(Alarm alarm) async {
    final repository = ref.read(alarmRepositoryProvider);
    await repository.createAlarm(alarm);
    ref.invalidateSelf();
  }
}
```

---

## 4. 核心服務設計

### 4.1 鬧鐘觸發機制

由於 iOS 背景執行限制，採用以下策略：

```
┌────────────────────────────────────────────────────────────────┐
│                     鬧鐘觸發流程                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. 使用者設定鬧鐘                                              │
│         │                                                      │
│         ▼                                                      │
│  2. 排程 Local Notification (UNUserNotificationCenter)         │
│     - 設定 categoryIdentifier                                  │
│     - 設定 sound: 使用自訂 15 秒鬧鈴檔案                        │
│         │                                                      │
│         ▼                                                      │
│  3. 時間到達 → iOS 系統觸發 Notification                        │
│         │                                                      │
│         ▼                                                      │
│  4. 使用者點擊通知 → App 開啟 (或從背景喚醒)                     │
│         │                                                      │
│         ▼                                                      │
│  5. App 顯示「鬧鐘響起」頁面                                    │
│         │                                                      │
│         ├──→ 5a. 繼續播放鈴聲 (如有需要)                        │
│         │                                                      │
│         ▼                                                      │
│  6. 15 秒後自動開始 TTS 播報新聞                                │
│         │                                                      │
│         ▼                                                      │
│  7. 播報完畢 / 使用者點擊停止                                   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 4.2 新聞獲取 & AI 摘要流程

```
┌────────────────────────────────────────────────────────────────┐
│                     新聞處理流程                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. 定時背景任務 (Background Fetch) 或鬧鐘觸發前預取            │
│         │                                                      │
│         ▼                                                      │
│  2. 並行獲取 RSS Feeds:                                        │
│     ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│     │ Google News │ │  MSN News   │ │ Yahoo News  │           │
│     └──────┬──────┘ └──────┬──────┘ └──────┬──────┘           │
│            │               │               │                   │
│            └───────────────┼───────────────┘                   │
│                            ▼                                   │
│  3. 合併 & 去重 & 排序 (依時間)                                 │
│         │                                                      │
│         ▼                                                      │
│  4. 取前 N 則新聞 (使用者設定數量)                              │
│         │                                                      │
│         ▼                                                      │
│  5. 呼叫 Gemini API 生成摘要                                   │
│     - Prompt: 要求生成適合語音播報的摘要                       │
│     - 限制字數、語氣                                           │
│         │                                                      │
│         ▼                                                      │
│  6. 快取摘要結果 (避免重複請求)                                 │
│         │                                                      │
│         ▼                                                      │
│  7. TTS 播報                                                   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 4.3 TTS 服務封裝

```dart
// TTS Service Interface
abstract class TTSService {
  Future<void> speak(String text, {String? language});
  Future<void> stop();
  Future<void> pause();
  Future<void> resume();
  Stream<TTSState> get stateStream;
  Future<List<TTSVoice>> getAvailableVoices();
  Future<void> setVoice(TTSVoice voice);
  Future<void> setRate(double rate); // 0.0 - 1.0
  Future<void> setPitch(double pitch); // 0.5 - 2.0
}

// iOS Implementation using AVSpeechSynthesizer
class IOSTTSService implements TTSService {
  // 透過 Method Channel 呼叫 iOS Native AVSpeechSynthesizer
}
```

---

## 5. 資料模型

### 5.1 Alarm Entity

```dart
class Alarm {
  final String id;
  final TimeOfDay time;
  final bool isEnabled;
  final RepeatType repeatType;
  final Set<DayOfWeek>? customDays; // 自訂重複日
  final String ringtoneId;
  final String label;
  final int newsCount; // 播報新聞數量
  final List<NewsSource> newsSources;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum RepeatType {
  once,      // 單次
  daily,     // 每日
  weekdays,  // 工作日 (週一~五)
  weekends,  // 週末 (週六日)
  custom,    // 自訂
}

enum DayOfWeek {
  monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

enum NewsSource {
  googleNews,
  msnNews,
  yahooNews,
}
```

### 5.2 NewsItem Entity

```dart
class NewsItem {
  final String id;
  final String title;
  final String? description;
  final String? content;
  final String source;
  final String sourceUrl;
  final DateTime publishedAt;
  final String? imageUrl;
  final String? summary; // AI 生成的摘要
}
```

### 5.3 AppSettings Entity

```dart
class AppSettings {
  final double ttsRate;          // TTS 語速
  final double ttsPitch;         // TTS 音調
  final String ttsVoiceId;       // 選擇的語音
  final double alarmVolume;      // 鬧鈴音量
  final int defaultNewsCount;    // 預設新聞數量
  final List<NewsSource> defaultNewsSources;
  final String defaultRingtoneId;
}
```

---

## 6. 第三方套件

### 6.1 必要套件

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 狀態管理
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # 網路請求
  dio: ^5.4.0

  # 本地儲存
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2

  # 通知
  flutter_local_notifications: ^16.3.0

  # 音訊
  just_audio: ^0.9.36
  audio_session: ^0.1.18

  # RSS 解析
  webfeed: ^0.7.0

  # 日期處理
  intl: ^0.18.1

  # 安全儲存 (API Key)
  flutter_secure_storage: ^9.0.0

  # 路由
  go_router: ^13.0.0

  # UI 元件
  cupertino_icons: ^1.0.6

  # 工具
  uuid: ^4.2.2
  equatable: ^2.0.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

  # 程式碼生成
  build_runner: ^2.4.8
  riverpod_generator: ^2.3.9
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
```

### 6.2 iOS 原生設定

需要在 `ios/` 目錄進行的設定：

1. **Info.plist** - 背景模式 & 權限

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>fetch</string>
    <string>processing</string>
</array>

<key>NSUserNotificationAlertStyle</key>
<string>alert</string>
```

2. **AppDelegate.swift** - 通知註冊

3. **Capabilities** - Push Notifications, Background Modes

---

## 7. API 設計

### 7.1 Gemini API 整合

```dart
// Prompt 設計
const String summarizePrompt = '''
你是一位專業的新聞播報員。請將以下新聞摘要成適合語音播報的形式。

要求：
1. 每則新聞摘要控制在 50-80 字
2. 使用口語化的表達，適合聽覺理解
3. 重點突出，去除冗餘資訊
4. 語氣專業但親切

新聞內容：
{news_content}

請輸出摘要：
''';
```

### 7.2 RSS Feed URLs

```dart
const Map<NewsSource, String> rssFeedUrls = {
  NewsSource.googleNews: 'https://news.google.com/rss?hl=zh-TW&gl=TW&ceid=TW:zh-Hant',
  NewsSource.msnNews: 'https://rss.msn.com/zh-tw/',
  NewsSource.yahooNews: 'https://tw.news.yahoo.com/rss/',
};
```

---

## 8. 錯誤處理策略

### 8.1 錯誤分類

```dart
sealed class AppFailure {
  const AppFailure();
}

class NetworkFailure extends AppFailure {
  final String message;
  const NetworkFailure(this.message);
}

class RSSParseFailure extends AppFailure {
  final String source;
  const RSSParseFailure(this.source);
}

class AIServiceFailure extends AppFailure {
  final String message;
  const AIServiceFailure(this.message);
}

class TTSFailure extends AppFailure {
  final String message;
  const TTSFailure(this.message);
}

class StorageFailure extends AppFailure {
  final String message;
  const StorageFailure(this.message);
}
```

### 8.2 Fallback 策略

| 失敗情境     | Fallback 策略                        |
| ------------ | ------------------------------------ |
| 網路不可用   | 使用快取的新聞，無快取則只播放鬧鈴   |
| RSS 獲取失敗 | 嘗試其他新聞來源，全失敗則通知使用者 |
| AI 摘要失敗  | 直接播報原始標題                     |
| TTS 失敗     | 顯示文字版新聞，播放鈴聲提示         |

---

## 9. 測試策略

### 9.1 單元測試

- Repository 層測試
- UseCase 層測試
- Provider 狀態測試

### 9.2 Widget 測試

- 關鍵頁面 Widget 測試
- 使用者流程測試

### 9.3 整合測試

- 完整鬧鐘設定流程
- 鬧鐘觸發流程

---

## 10. 未來擴展性

### 10.1 後端遷移準備

目前設計已考慮未來遷移至 Go 後端：

1. **Repository Pattern**: 資料層解耦，切換 API 只需替換 Repository 實作
2. **API 介面統一**: 預先定義 API Response 格式
3. **本地優先**: MVP 使用本地儲存，遷移時只需加入同步邏輯

### 10.2 擴展點

- 新增新聞來源：新增 `NewsSource` enum + RSS URL
- 新增 AI 服務：實作 `AISummaryDataSource` 介面
- 新增 TTS 服務：實作 `TTSService` 介面
