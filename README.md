# AI 新聞鬧鐘 (AI News Alarm Clock)

一款結合智慧新聞播報的 iOS 鬧鐘 App，讓你在起床時透過語音接收當日新聞摘要。

## ✨ 功能特色

- 🕐 **多組鬧鐘** - 支援設定多個鬧鐘，可設定每日、工作日、週末或自訂重複
- 📰 **AI 新聞摘要** - 自動從 Google/MSN/Yahoo 新聞獲取最新資訊並生成摘要
- 🔊 **語音播報** - 使用系統 TTS 朗讀新聞摘要
- 🎵 **漸進喚醒** - 先播放 15 秒鬧鈴，再自動切換至新聞播報

## 📱 技術棧

| 項目     | 技術                    |
| -------- | ----------------------- |
| 框架     | Flutter 3.x             |
| 語言     | Dart                    |
| 平台     | iOS 15.0+               |
| 狀態管理 | Riverpod 2.x            |
| 架構     | Clean Architecture      |
| 本地儲存 | Hive                    |
| AI 摘要  | Google Gemini API       |
| TTS      | iOS AVSpeechSynthesizer |

## 📖 文件

詳細規格文件位於 `docs/` 目錄：

| 文件                                                        | 說明            |
| ----------------------------------------------------------- | --------------- |
| [PRD.md](docs/PRD.md)                                       | 產品需求文件    |
| [TECHNICAL_ARCHITECTURE.md](docs/TECHNICAL_ARCHITECTURE.md) | 技術架構設計    |
| [AI_DEVELOPMENT_GUIDE.md](docs/AI_DEVELOPMENT_GUIDE.md)     | AI 輔助開發指引 |
| [UI_SPEC.md](docs/UI_SPEC.md)                               | UI/UX 設計規格  |
| [WORKFLOW.md](docs/WORKFLOW.md)                             | 開發工作流程    |

## 🚀 快速開始

### 環境需求

- Flutter 3.x
- Dart 3.x
- Xcode 15.0+
- CocoaPods 1.12+

### 安裝

```bash
# Clone 專案
git clone https://github.com/your-username/ai_alarm_clock.git
cd ai_alarm_clock

# 安裝依賴
flutter pub get

# 生成程式碼
dart run build_runner build --delete-conflicting-outputs

# iOS 依賴
cd ios && pod install && cd ..

# 執行
flutter run
```

## 📂 專案結構

```
lib/
├── core/           # 核心基礎設施
├── features/       # 功能模組
│   ├── alarm/      # 鬧鐘管理
│   ├── news/       # 新聞獲取
│   ├── alarm_trigger/  # 鬧鐘觸發
│   └── settings/   # 設定
├── shared/         # 共享元件
└── main.dart
```

## 🗺️ 開發路線圖

- [x] 規格文件制定
- [ ] Phase 1: MVP 基礎功能
  - [ ] 鬧鐘管理 CRUD
  - [ ] RSS 新聞獲取
  - [ ] AI 摘要整合
  - [ ] TTS 播報
- [ ] Phase 2: 優化
  - [ ] UI/UX 優化
  - [ ] 新聞類別篩選
- [ ] Phase 3: 上架
  - [ ] App Store 審核
  - [ ] 正式發布

## 📄 License

MIT License
