# AI 新聞鬧鐘 App - 首頁實作 Walkthrough

## 已完成的工作

### 功能概述

實作了鬧鐘列表首頁，使用者可以：

- 查看所有已設定的鬧鐘
- 新增 / 編輯 / 刪除鬧鐘
- 設定時間、重複週期和標籤
- 開關個別鬧鐘

---

## 專案結構

```
lib/
├── main.dart                          # App 入口
├── features/
│   └── alarm/
│       ├── domain/                    # Domain 層
│       │   ├── entities/
│       │   │   ├── alarm.dart
│       │   │   ├── repeat_type.dart
│       │   │   └── day_of_week.dart
│       │   └── repositories/
│       │       └── alarm_repository.dart
│       ├── data/                      # Data 層
│       │   ├── models/
│       │   │   ├── alarm_model.dart
│       │   │   └── alarm_model.g.dart (generated)
│       │   ├── mappers/
│       │   │   └── alarm_mapper.dart
│       │   ├── datasources/
│       │   │   └── alarm_local_datasource.dart
│       │   └── repositories/
│       │       └── alarm_repository_impl.dart
│       └── presentation/              # Presentation 層
│           ├── providers/
│           │   └── alarm_provider.dart
│           ├── pages/
│           │   ├── alarm_list_page.dart
│           │   └── alarm_edit_page.dart
│           └── widgets/
│               └── alarm_card.dart
└── shared/
    └── theme/
        └── app_theme.dart
```

---

## 新增的依賴套件

```yaml
# State Management
flutter_riverpod: ^2.4.9

# Local Storage
hive: ^2.2.3
hive_flutter: ^1.1.0

# Utilities
uuid: ^4.2.2
equatable: ^2.0.5
intl: ^0.19.0

# Code Generation
freezed_annotation: ^2.4.1
build_runner: ^2.4.8
hive_generator: ^2.0.1
```

---

## 頁面截圖說明

### 鬧鐘列表頁

- 顯示所有鬧鐘，按時間排序
- 每個鬧鐘卡片顯示：時間、標籤、重複設定、開關
- 空狀態時顯示引導文字

### 新增/編輯鬧鐘頁

- CupertinoDatePicker 選擇時間
- 重複設定選項（只響一次、每日、工作日、週末）
- 標籤輸入欄位
- 編輯模式顯示刪除按鈕

---

## 如何測試

```bash
# 確認依賴已安裝
flutter pub get

# 生成 Hive adapter
dart run build_runner build --delete-conflicting-outputs

# 執行 App
flutter run -d "iPhone 15"
```

### 測試流程

1. App 啟動後進入空狀態頁面
2. 點擊「新增鬧鐘」或右上角 + 按鈕
3. 選擇時間、重複週期、標籤
4. 點擊「儲存」返回列表
5. 點擊鬧鐘卡片可編輯
6. 使用開關可啟用/停用鬧鐘

---

## 下一步開發

- [ ] 新聞獲取功能 (RSS Feed)
- [ ] AI 摘要功能 (Gemini API)
- [ ] TTS 語音播報
- [ ] Local Notification 鬧鐘觸發
