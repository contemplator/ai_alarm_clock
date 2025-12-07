---
description: 開發 AI 新聞鬧鐘 App 的開發指引
---

# AI 新聞鬧鐘 App 開發指引

在開始任何開發工作前，請先閱讀以下規格文件：

## 必讀文件

1. **PRD (產品需求)**: `docs/PRD.md`
2. **技術架構**: `docs/TECHNICAL_ARCHITECTURE.md`
3. **AI 開發指引**: `docs/AI_DEVELOPMENT_GUIDE.md`
4. **UI 規格**: `docs/UI_SPEC.md`
5. **開發工作流程**: `docs/WORKFLOW.md`

## 開發規範

### 架構

- 使用 Clean Architecture (Domain → Data → Presentation)
- 狀態管理使用 Riverpod 2.x
- 每個功能模組放在 `lib/features/[feature]/` 下

### 專案結構

```
lib/
├── core/           # 核心基礎設施
├── features/       # 功能模組
│   └── [feature]/
│       ├── data/         # 資料層
│       ├── domain/       # 領域層
│       └── presentation/ # 展示層
├── shared/         # 共享元件
└── main.dart
```

### 編碼規範

- 檔案名: snake_case
- 類別名: PascalCase
- 變數/函數: camelCase
- 避免使用 dynamic 類型
- 善用 null safety

### 實作順序

開發新功能時，請按以下順序：

1. Domain 層 (entities, repositories 抽象, usecases)
2. Data 層 (models, datasources, repositories 實作)
3. Presentation 層 (providers, pages, widgets)
4. 撰寫測試

## 常用指令

// turbo-all

```bash
# 安裝依賴
flutter pub get

# 程式碼生成
dart run build_runner build --delete-conflicting-outputs

# 執行測試
flutter test

# 靜態分析
flutter analyze
```

## 注意事項

- iOS 鬧鐘需要使用 Local Notification，不能依賴背景執行
- TTS 使用系統內建 AVSpeechSynthesizer
- 新聞來源使用 RSS Feed (Google/MSN/Yahoo News)
- AI 摘要使用 Google Gemini API
