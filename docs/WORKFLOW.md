# AI 新聞鬧鐘 App - 開發工作流程

> **版本**: 1.0.0  
> **最後更新**: 2025-12-07

---

## 1. 開發環境設置

### 1.1 必備工具

| 工具                     | 版本  | 用途         |
| ------------------------ | ----- | ------------ |
| Flutter                  | 3.x   | 開發框架     |
| Dart                     | 3.x   | 程式語言     |
| Xcode                    | 15.0+ | iOS 編譯     |
| VS Code / Android Studio | 最新  | IDE          |
| CocoaPods                | 1.12+ | iOS 依賴管理 |

### 1.2 環境安裝檢查

```bash
# 檢查 Flutter 環境
flutter doctor

# 預期輸出應該全部是 ✓
# [✓] Flutter
# [✓] Xcode
# [✓] Chrome (可選，Web 開發用)
# [✓] VS Code
```

### 1.3 專案初始化

```bash
# 進入專案目錄
cd ai_alarm_clock

# 安裝依賴
flutter pub get

# 生成程式碼 (Riverpod, Freezed, Hive)
dart run build_runner build --delete-conflicting-outputs

# iOS 依賴設置
cd ios
pod install
cd ..
```

---

## 2. 開發流程

### 2.1 分支策略

```
main           ← 穩定版本，只接受 PR
  │
  └── develop  ← 開發中版本
        │
        ├── feature/alarm-list     ← 功能分支
        ├── feature/news-fetch
        ├── fix/tts-crash          ← Bug 修復
        └── refactor/clean-arch    ← 重構
```

### 2.2 開發週期

```
┌─────────────────────────────────────────────────────────┐
│                      開發流程                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. 建立 Feature 分支                                   │
│     └── git checkout -b feature/功能名稱                │
│                                                         │
│  2. 開發功能 (遵循 Clean Architecture)                  │
│     └── Domain → Data → Presentation                   │
│                                                         │
│  3. 撰寫測試                                            │
│     └── unit test → widget test                        │
│                                                         │
│  4. 本地驗證                                            │
│     └── flutter test && flutter analyze                │
│                                                         │
│  5. 提交 PR 到 develop                                  │
│     └── 程式碼審查 → 合併                               │
│                                                         │
│  6. 功能完成後合併 develop → main                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 3. 常用指令

### 3.1 日常開發

```bash
# 執行 App (iOS 模擬器)
flutter run -d "iPhone 15"

# 熱重載已包含在 flutter run，按 'r' 即可
# 熱重啟按 'R' (會清除狀態)

# 只編譯不執行
flutter build ios --debug

# 清除並重新編譯
flutter clean && flutter pub get && flutter run
```

### 3.2 程式碼生成

```bash
# 一次性生成 (推薦)
dart run build_runner build --delete-conflicting-outputs

# 持續監聽變更自動生成
dart run build_runner watch --delete-conflicting-outputs
```

### 3.3 測試

```bash
# 執行所有測試
flutter test

# 執行特定測試
flutter test test/features/alarm/

# 帶覆蓋率的測試
flutter test --coverage

# 查看覆蓋率報告
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### 3.4 程式碼品質

```bash
# 靜態分析
flutter analyze

# 修正格式問題
dart format lib/ test/

# 修正 import 排序
dart fix --apply
```

### 3.5 iOS 專用

```bash
# 更新 CocoaPods
cd ios && pod install --repo-update && cd ..

# 清除 iOS 建置快取
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..

# 開啟 Xcode 專案
open ios/Runner.xcworkspace
```

---

## 4. AI 輔助開發工作流

### 4.1 開始新功能

```markdown
## 給 AI 的任務說明範本

### 任務

實作 [功能名稱]

### 背景

- 相關規格：參考 docs/PRD.md 第 X 節
- 技術架構：參考 docs/TECHNICAL_ARCHITECTURE.md

### 要求

1. 遵循 Clean Architecture (Domain → Data → Presentation)
2. 使用 Riverpod 管理狀態
3. 包含單元測試

### 預期輸出

- lib/features/[feature]/domain/...
- lib/features/[feature]/data/...
- lib/features/[feature]/presentation/...
- test/features/[feature]/...

### 分步驟執行

請先實作 Domain 層，完成後等我確認再繼續。
```

### 4.2 Debug 工作流

```markdown
## Bug 回報範本

### 問題描述

[簡述問題]

### 重現步驟

1. ...
2. ...
3. ...

### 預期行為

[應該發生什麼]

### 實際行為

[實際發生什麼]

### 錯誤訊息
```

[貼上完整錯誤訊息]

```

### 相關檔案
- lib/features/alarm/...

### 環境
- Flutter: x.x.x
- iOS: x.x
- 裝置: iPhone xx
```

### 4.3 程式碼審查清單

當 AI 完成程式碼後，檢查以下項目：

- [ ] 遵循 Clean Architecture 分層
- [ ] 沒有硬編碼字串/數值
- [ ] 有適當的錯誤處理
- [ ] 沒有 dynamic 類型
- [ ] Provider 使用正確
- [ ] Widget 建構函式有 const
- [ ] 有對應的測試檔案
- [ ] 程式碼通過 `flutter analyze`

---

## 5. 測試裝置

### 5.1 iOS 模擬器

```bash
# 列出可用模擬器
flutter devices

# 開啟特定模擬器
open -a Simulator
# 或
xcrun simctl boot "iPhone 15"

# 執行在特定模擬器
flutter run -d "iPhone 15"
```

### 5.2 真機測試 (需要 Apple Developer 帳號)

1. 在 Xcode 設定 Team (Signing & Capabilities)
2. 連接 iPhone
3. 信任開發者憑證 (設定 → 一般 → VPN 與裝置管理)
4. `flutter run -d [device_id]`

### 5.3 TestFlight 部署

```bash
# 建置 iOS Release
flutter build ios --release

# 在 Xcode 中
# 1. Product → Archive
# 2. Distribute App → App Store Connect
# 3. 上傳後在 App Store Connect 設定 TestFlight
```

---

## 6. 版本管理

### 6.1 版本號規則

格式：`major.minor.patch+build`

| 欄位  | 用途              | 範例    |
| ----- | ----------------- | ------- |
| major | 不相容的 API 更改 | 2.0.0   |
| minor | 新增功能          | 1.1.0   |
| patch | Bug 修復          | 1.0.1   |
| build | 每次建置遞增      | 1.0.0+5 |

### 6.2 更新版本

在 `pubspec.yaml` 中：

```yaml
version: 1.0.1+6
```

---

## 7. 檔案模板

### 7.1 新增 Feature 結構

```bash
# 建立新功能的目錄結構
mkdir -p lib/features/{feature_name}/{data,domain,presentation}/{datasources,models,repositories,entities,usecases,providers,pages,widgets}
```

### 7.2 Entity 模板

```dart
// lib/features/example/domain/entities/example.dart
import 'package:equatable/equatable.dart';

class Example extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;

  const Example({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, createdAt];

  Example copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return Example(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

### 7.3 Repository 模板

```dart
// lib/features/example/domain/repositories/example_repository.dart
import '../entities/example.dart';

abstract class ExampleRepository {
  Future<List<Example>> getAll();
  Future<Example?> getById(String id);
  Future<void> create(Example example);
  Future<void> update(Example example);
  Future<void> delete(String id);
}
```

### 7.4 Provider 模板

```dart
// lib/features/example/presentation/providers/example_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'example_provider.g.dart';

@riverpod
class ExampleNotifier extends _$ExampleNotifier {
  @override
  Future<List<Example>> build() async {
    return _fetchExamples();
  }

  Future<List<Example>> _fetchExamples() async {
    final repository = ref.read(exampleRepositoryProvider);
    return repository.getAll();
  }

  Future<void> add(Example example) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(exampleRepositoryProvider).create(example);
      return _fetchExamples();
    });
  }
}
```

---

## 8. 常見問題排解

### 8.1 建置問題

**問題：CocoaPods 版本衝突**

```bash
cd ios && pod deintegrate && pod install && cd ..
```

**問題：Flutter 版本不符**

```bash
flutter upgrade
flutter pub upgrade
```

**問題：程式碼生成失敗**

```bash
flutter clean
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### 8.2 執行問題

**問題：iOS 模擬器無法啟動**

```bash
sudo xcode-select --reset
xcrun simctl shutdown all
xcrun simctl erase all
```

**問題：Hot reload 沒有反應**

```
在終端機按 'R' 進行 hot restart
```

---

## 9. 發布前檢查清單

### 9.1 功能檢查

- [ ] 所有核心功能正常運作
- [ ] 鬧鐘可以正確觸發
- [ ] 新聞可以正確獲取和播報
- [ ] TTS 語音播報正常

### 9.2 品質檢查

- [ ] 無 console error
- [ ] 無明顯 UI bug
- [ ] 效能可接受 (FPS 穩定)
- [ ] 記憶體無明顯洩漏

### 9.3 App Store 準備

- [ ] App Icon 已設定
- [ ] Launch Screen 已設定
- [ ] App 名稱、描述已準備
- [ ] 螢幕截圖已準備
- [ ] 隱私政策 URL 已準備

---

## 附錄

### A. 參考連結

- [Flutter 官方文件](https://docs.flutter.dev/)
- [Riverpod 官方文件](https://riverpod.dev/)
- [Apple Developer](https://developer.apple.com/)
- [App Store Connect](https://appstoreconnect.apple.com/)

### B. 相關文件

- [PRD.md](./PRD.md)
- [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md)
- [AI_DEVELOPMENT_GUIDE.md](./AI_DEVELOPMENT_GUIDE.md)
- [UI_SPEC.md](./UI_SPEC.md)
