# AI 新聞鬧鐘 App - AI 開發指引

> **版本**: 1.0.0  
> **最後更新**: 2025-12-07  
> **用途**: 在使用 AI 輔助開發時，將此文件作為 Context/System Prompt 提供

---

## 📋 快速開始 Prompt

當開始新的 AI 開發對話時，可使用以下 Prompt：

```
我正在開發一個 iOS 鬧鐘 App「AI 新聞鬧鐘」，使用 Flutter 框架。

專案基本資訊：
- 框架: Flutter 3.x + Dart
- 目標平台: iOS 15.0+
- 狀態管理: Riverpod 2.x
- 架構: Clean Architecture (Data/Domain/Presentation 分層)

核心功能：
1. 多組鬧鐘管理 (支援重複設定)
2. RSS 新聞獲取 (Google/MSN/Yahoo News)
3. AI 新聞摘要 (Gemini API)
4. 系統 TTS 語音播報

完整規格文件位於 docs/ 目錄：
- PRD.md: 產品需求
- TECHNICAL_ARCHITECTURE.md: 技術架構
- AI_DEVELOPMENT_GUIDE.md: 開發指引
- UI_SPEC.md: UI 規格

請先閱讀這些文件，然後協助我進行開發。
```

---

## 🎯 專案背景 (Context)

### 產品概述

AI 新聞鬧鐘是一款 iOS 鬧鐘 App，當鬧鐘時間到達時：

1. 先播放 15 秒的鬧鈴
2. 自動切換至 AI 摘要的新聞語音播報

### 技術決策

| 決策項目 | 選擇                         | 原因                 |
| -------- | ---------------------------- | -------------------- |
| 框架     | Flutter                      | 跨平台，未來可擴展   |
| 狀態管理 | Riverpod                     | 類型安全，測試友好   |
| 架構模式 | Clean Architecture           | 可維護性，可測試性   |
| TTS      | iOS 系統 AVSpeechSynthesizer | 免費、穩定、離線可用 |
| 本地儲存 | Hive                         | 高效能 NoSQL         |
| AI 服務  | Google Gemini                | 多語言支援，成本合理 |

### 專案結構概覽

```
lib/
├── core/           # 核心基礎設施 (網路、服務、工具)
├── features/       # 功能模組 (alarm, news, settings)
│   └── [feature]/
│       ├── data/         # 資料層
│       ├── domain/       # 領域層
│       └── presentation/ # 展示層
├── shared/         # 共享元件 (widgets, theme)
└── main.dart
```

---

## 🔧 編碼規範

### Dart/Flutter 風格

#### 命名規則

```dart
// 檔案名: snake_case
alarm_repository.dart
alarm_card.dart

// 類別名: PascalCase
class AlarmRepository {}
class AlarmCard extends StatelessWidget {}

// 變數/函數: camelCase
final alarmList = <Alarm>[];
void createAlarm() {}

// 常數: 使用 static const 或 top-level const
const int maxAlarmCount = 20;

class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
}

// 私有成員: 底線前綴
String _privateField;
void _privateMethod() {}
```

#### 型別宣告

```dart
// ✅ 明確型別宣告
final List<Alarm> alarms = [];
final Map<String, int> counts = {};

// ✅ 可推斷時省略
final alarm = Alarm(time: TimeOfDay.now());  // 型別明顯
var count = 0;  // 簡單初始化

// ❌ 避免 dynamic
dynamic data;  // 不要使用
```

#### 空安全 (Null Safety)

```dart
// ✅ 優先使用非空型別
final String title;

// ✅ 可空時明確處理
final String? description;
final text = description ?? 'No description';

// ❌ 避免強制解包，除非確定不為 null
widget.description!;  // 危險

// ✅ 使用 if-null 或 null-aware operators
widget.description?.toUpperCase() ?? 'DEFAULT';
```

### 檔案組織

#### 每個 Feature 的結構

```
features/alarm/
├── data/
│   ├── datasources/
│   │   └── alarm_local_datasource.dart   # 本地資料來源
│   ├── models/
│   │   └── alarm_model.dart              # 資料模型 (JSON/Hive)
│   └── repositories/
│       └── alarm_repository_impl.dart    # Repository 實作
│
├── domain/
│   ├── entities/
│   │   └── alarm.dart                    # 業務實體 (純 Dart)
│   ├── repositories/
│   │   └── alarm_repository.dart         # Repository 抽象
│   └── usecases/
│       ├── create_alarm.dart
│       ├── update_alarm.dart
│       └── get_alarms.dart
│
└── presentation/
    ├── providers/
    │   └── alarm_provider.dart           # Riverpod Provider
    ├── pages/
    │   └── alarm_list_page.dart          # 頁面
    └── widgets/
        └── alarm_card.dart               # UI 元件
```

### Riverpod 使用規範

#### Provider 定義

```dart
// ✅ 使用 riverpod_generator 的 @riverpod 註解
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alarm_provider.g.dart';

// 簡單資料 Provider
@riverpod
AlarmRepository alarmRepository(AlarmRepositoryRef ref) {
  return AlarmRepositoryImpl(
    localDataSource: ref.watch(alarmLocalDataSourceProvider),
  );
}

// 非同步資料 Provider
@riverpod
Future<List<Alarm>> alarmList(AlarmListRef ref) async {
  final repository = ref.watch(alarmRepositoryProvider);
  return repository.getAlarms();
}

// 可變狀態 Provider (Notifier)
@riverpod
class AlarmNotifier extends _$AlarmNotifier {
  @override
  Future<List<Alarm>> build() async {
    return _fetchAlarms();
  }

  Future<void> addAlarm(Alarm alarm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(alarmRepositoryProvider).createAlarm(alarm);
      return _fetchAlarms();
    });
  }
}
```

#### Provider 使用

```dart
// ✅ 在 Widget 中使用
class AlarmListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(alarmListProvider);

    return alarmsAsync.when(
      data: (alarms) => ListView.builder(...),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}

// ✅ 觸發動作
onPressed: () {
  ref.read(alarmNotifierProvider.notifier).addAlarm(newAlarm);
}
```

### 錯誤處理

#### Result 模式

```dart
// 使用 sealed class 表示結果
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}

// 使用範例
Future<Result<List<NewsItem>>> fetchNews() async {
  try {
    final news = await _fetchFromRss();
    return Success(news);
  } on NetworkException catch (e) {
    return Failure(NetworkFailure(e.message));
  }
}
```

---

## 📐 UI/Widget 規範

### Widget 設計原則

```dart
// ✅ 小型、可重用的 Widget
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
    return Card(
      child: ListTile(
        title: Text(_formatTime(alarm.time)),
        subtitle: Text(alarm.label),
        trailing: Switch(
          value: alarm.isEnabled,
          onChanged: onToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}
```

### 主題使用

```dart
// ✅ 使用 Theme 取得顏色/樣式
final primaryColor = Theme.of(context).colorScheme.primary;
final textStyle = Theme.of(context).textTheme.headlineMedium;

// ❌ 避免硬編碼顏色
Color(0xFF123456);  // 不要這樣做
```

### Responsive 設計

```dart
// ✅ 使用 MediaQuery 適配
final screenWidth = MediaQuery.of(context).size.width;
final isSmallScreen = screenWidth < 375;

// ✅ 使用 LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return _buildTabletLayout();
    }
    return _buildPhoneLayout();
  },
)
```

---

## 🧪 測試規範

### 測試檔案命名

```
test/
├── features/
│   └── alarm/
│       ├── data/
│       │   └── alarm_repository_impl_test.dart
│       ├── domain/
│       │   └── create_alarm_test.dart
│       └── presentation/
│           ├── alarm_provider_test.dart
│           └── alarm_card_test.dart
└── core/
    └── services/
        └── tts_service_test.dart
```

### 測試結構

```dart
void main() {
  group('AlarmRepository', () {
    late AlarmRepository repository;
    late MockAlarmLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockAlarmLocalDataSource();
      repository = AlarmRepositoryImpl(localDataSource: mockDataSource);
    });

    group('getAlarms', () {
      test('should return list of alarms from local data source', () async {
        // Arrange
        when(() => mockDataSource.getAlarms()).thenAnswer(
          (_) async => [testAlarmModel],
        );

        // Act
        final result = await repository.getAlarms();

        // Assert
        expect(result, isA<List<Alarm>>());
        expect(result.length, 1);
      });
    });
  });
}
```

---

## 📝 常用 Prompt 範例

### 新增功能

```
請在 features/alarm/ 下新增「鬧鐘標籤編輯」功能：

功能需求：
- 使用者可以為鬧鐘設定自訂標籤
- 標籤長度限制 20 字元
- 預設標籤為「鬧鐘」

請按照 Clean Architecture 分層：
1. Domain: 更新 Alarm entity
2. Data: 更新 AlarmModel
3. Presentation: 新增標籤編輯 Widget

請逐步實作，每個檔案完成後等我確認再繼續。
```

### 修復 Bug

```
我遇到一個 Bug：[描述問題]

相關檔案：
- lib/features/alarm/presentation/pages/alarm_list_page.dart

錯誤訊息：
[貼上錯誤訊息]

請分析原因並提供修復方案。
```

### 程式碼重構

```
請重構以下程式碼，遵循專案的編碼規範：

[貼上程式碼]

重構要點：
1. 遵循 Clean Architecture 分層
2. 使用 Riverpod 管理狀態
3. 加入適當的錯誤處理
```

### UI 實作

```
請根據 UI_SPEC.md 的設計，實作「鬧鐘列表頁面」：

頁面路徑：lib/features/alarm/presentation/pages/alarm_list_page.dart

需求：
- 顯示所有鬧鐘列表
- 空狀態顯示引導文字
- 右上角「+」按鈕新增鬧鐘
- 每個鬧鐘卡片可開關、點擊編輯

請使用 ConsumerWidget 和專案的共享 Widget。
```

---

## ⚠️ 重要提醒

### 必須遵守

1. **遵循 Clean Architecture 分層**：Domain 層不依賴 Data 層
2. **使用 Riverpod**：不要使用其他狀態管理方案
3. **型別安全**：避免 dynamic，善用 null safety
4. **iOS 限制**：了解 iOS 背景執行限制，鬧鐘使用 Local Notification

### 常見錯誤

1. **不要**在 Domain 層 import Flutter 套件 (除 foundation)
2. **不要**直接在 Widget 中進行 API 呼叫
3. **不要**硬編碼字串，使用 constants
4. **不要**忽略錯誤處理

### iOS 特別注意事項

```dart
// ✅ 使用 flutter_local_notifications 排程鬧鐘
// ✅ 鬧鈴音檔需放在 ios/ 目錄並正確設定
// ✅ 需要處理通知權限請求
// ❌ 不能依賴背景持續運行
// ❌ 不能保證 App 在背景時執行 Dart 程式碼
```

---

## 🔗 相關文件

- [PRD.md](./PRD.md) - 產品需求文件
- [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md) - 技術架構
- [UI_SPEC.md](./UI_SPEC.md) - UI/UX 規格
- [Flutter 官方文件](https://docs.flutter.dev/)
- [Riverpod 官方文件](https://riverpod.dev/)
