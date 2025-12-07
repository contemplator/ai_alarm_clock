# AI 新聞鬧鐘 App - 規格文件規劃

## 目標

為 iOS 鬧鐘 App 建立完整的規格文件，供後續 AI 輔助開發使用。

## 使用者需求摘要

### 產品需求

- **鬧鐘功能**：多組鬧鐘、重複設定（每日/工作日/週末/自訂）、無貪睡
- **鬧鈴**：從 App 內建鈴聲選擇，播放約 15 秒
- **新聞播報**：鬧鈴後自動播放 AI 摘要的新聞
- **新聞來源**：Google 新聞、MSN 新聞、Yahoo 新聞 (RSS)
- **TTS**：使用系統內建 TTS（免費、穩定、離線可用）

### 技術決策

- **框架**：Flutter
- **目標平台**：iOS 15.0+
- **後端**：MVP 階段全部在 iOS 端處理，未來可遷移至 Go Server

---

## 已建立的文件

### [PRD.md](file:///Users/leolin/programs/ai_alarm_clock/docs/PRD.md)

產品需求文件，包含：

- 產品願景與目標使用者
- 核心功能需求（鬧鐘管理、鈴聲設定、新聞播報）
- 非功能需求（效能、可靠性、安全性）
- 使用者故事
- 里程碑規劃

---

### [TECHNICAL_ARCHITECTURE.md](file:///Users/leolin/programs/ai_alarm_clock/docs/TECHNICAL_ARCHITECTURE.md)

技術架構文件，包含：

- 技術棧總覽（Flutter, Riverpod, Hive, Gemini API）
- 專案目錄結構（Clean Architecture 分層）
- 核心服務設計（鬧鐘觸發機制、新聞處理流程、TTS 服務）
- 資料模型（Alarm, NewsItem, AppSettings）
- 第三方套件清單
- 錯誤處理策略
- 後端遷移準備

---

### [AI_DEVELOPMENT_GUIDE.md](file:///Users/leolin/programs/ai_alarm_clock/docs/AI_DEVELOPMENT_GUIDE.md)

AI 開發指引，包含：

- 快速開始 Prompt 範本
- Dart/Flutter 編碼規範
- Riverpod 使用規範
- 錯誤處理模式 (Result Pattern)
- UI/Widget 規範
- 測試規範
- 常用 Prompt 範例（新增功能、修復 Bug、程式碼重構）
- iOS 特別注意事項

---

### [UI_SPEC.md](file:///Users/leolin/programs/ai_alarm_clock/docs/UI_SPEC.md)

UI/UX 規格文件，包含：

- 設計原則（簡潔直覺、iOS 原生風格、暗色優先）
- 色彩系統（Light/Dark Theme）
- 字體系統
- 頁面設計：
  - 鬧鐘列表頁
  - 新增/編輯鬧鐘頁
  - 設定頁
  - 鬧鐘響起頁
- 元件庫（按鈕、卡片、選擇器）
- 動畫規格
- 響應式設計
- 使用者流程圖

---

### [WORKFLOW.md](file:///Users/leolin/programs/ai_alarm_clock/docs/WORKFLOW.md)

開發工作流程文件，包含：

- 開發環境設置
- 分支策略
- 常用 Flutter/Dart 指令
- AI 輔助開發工作流（任務說明範本、Bug 回報範本）
- 程式碼審查清單
- 測試裝置設置
- TestFlight 部署流程
- 常見問題排解
- 發布前檢查清單

---

### [README.md](file:///Users/leolin/programs/ai_alarm_clock/README.md)

專案說明文件，更新內容包含：

- 功能特色描述
- 技術棧表格
- 文件索引連結
- 快速開始指南
- 專案結構概覽
- 開發路線圖

---

## 下一步建議

1. **審查規格文件**：確認內容符合預期
2. **設定開發環境**：按照 WORKFLOW.md 設置 Flutter 環境
3. **更新 pubspec.yaml**：加入建議的第三方套件
4. **開始 MVP 開發**：從 Domain 層開始建立 Alarm 功能

## 需要使用者決策的項目

> [!IMPORTANT]
> 以下項目需要您確認或提供：

1. **AI API Key**：需要 Google Gemini API Key 用於新聞摘要
2. **App Icon 設計**：是否需要設計 App Icon？
3. **鈴聲檔案**：是否有指定的鬧鈴音效？或使用免費素材？
