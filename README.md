# 名刺読み取りアプリケーション

名刺画像をアップロードして、Google Gemini 2.5 Flash APIを使用して自動的に名刺情報を抽出・表示するRails 8アプリケーションです。

## 🚀 機能

- 📷 名刺画像のアップロード（JPEG、PNG対応）
- 🤖 Google Gemini 2.5 Flash APIによる自動テキスト抽出
- 📊 構造化された名刺情報の表示
- 💾 読み取り結果のデータベース保存
- 🎨 レスポンシブなWebインターフェース

## 📋 要件

- Ruby 3.4.4+
- Rails 8.0.2
- SQLite3
- Google Gemini API キー

## 🛠 セットアップ

### 1. リポジトリのクローン
```bash
git clone <repository-url>
cd business_card_reader
```

### 2. 依存関係のインストール
```bash
bundle install
```

### 3. データベースのセットアップ
```bash
bin/rails db:setup
```

### 4. Google Gemini API キーの設定
```bash
EDITOR="code --wait" bin/rails credentials:edit
```

以下の内容を追加してください：
```yaml
google_api_key: YOUR_GOOGLE_API_KEY_HERE
```

Google AI Studio（https://aistudio.google.com/）でAPIキーを取得できます。

### 5. サーバーの起動
```bash
bin/rails server
```

アプリケーションは http://localhost:3000 で利用できます。

## 💻 使用方法

1. **名刺画像のアップロード**: トップページで名刺画像（JPEG/PNG）を選択
2. **読み取り開始**: 「読み取り開始」ボタンをクリック
3. **結果確認**: 自動的に抽出された名刺情報を確認

## 🏗 技術スタック

- **フレームワーク**: Rails 8.0.2
- **データベース**: SQLite3
- **AI API**: Google Gemini 2.5 Flash
- **画像処理**: Active Storage
- **フロントエンド**: Hotwire (Turbo + Stimulus)
- **スタイリング**: カスタムCSS（Utility-first スタイル）

## 📂 プロジェクト構造

```
app/
├── controllers/
│   └── business_cards_controller.rb  # メインコントローラー
├── models/
│   └── business_card.rb              # 名刺データモデル
├── services/
│   └── gemini_service.rb             # Gemini API統合サービス
└── views/
    └── business_cards/
        ├── new.html.erb              # アップロード画面
        └── show.html.erb             # 結果表示画面
```

## 📋 データベーススキーマ

```ruby
# business_cards テーブル
create_table "business_cards" do |t|
  t.string "full_name"           # 氏名
  t.string "company_name"        # 会社名
  t.string "department"          # 部署
  t.string "post"                # 役職
  t.string "telephone_number"    # 電話番号
  t.string "mail"                # メールアドレス
  t.text "address"               # 住所
  t.text "raw_response"          # API生レスポンス
  t.timestamps
end
```

## 🔧 開発コマンド

```bash
# サーバー起動
bin/rails server

# コンソール起動
bin/rails console

# データベースリセット
bin/rails db:reset

# コード品質チェック
bundle exec rubocop

# セキュリティスキャン
bundle exec brakeman
```

## 🚢 デプロイ

### Kamal（Docker）デプロイ

本アプリケーションはKamalを使用したDocker化デプロイに対応しています。

```bash
# デプロイ
bin/kamal deploy

# ログ確認
bin/kamal logs

# コンソールアクセス
bin/kamal console
```

### Render.com デプロイ

Render.comでの簡単デプロイも可能です：

1. `render.yaml`設定ファイルが用意済み
2. GitHubリポジトリを接続するだけで自動デプロイ
3. 無料プランで利用可能
4. 詳細な手順は`DEPLOY_RENDER.md`を参照

## 🔒 セキュリティ

- APIキーは暗号化されたcredentials.yml.encで管理
- ファイルアップロードは画像形式のみに制限
- CSRFトークンによる保護

## 🧪 テスト

```bash
# テスト実行（現在はテストフレームワーク未設定）
# bundle exec rspec
```

## 📈 拡張可能な機能

- [ ] 名刺一覧・検索機能
- [ ] 読み取り結果の手動編集
- [ ] CSV/vCardエクスポート
- [ ] 複数画像の一括処理
- [ ] ユーザー認証システム
- [ ] 読み取り履歴管理

## 🐛 トラブルシューティング

### よくある問題

**API Key not found エラー**
```bash
# credentials.yml.encの確認
bin/rails credentials:show
```

**画像アップロードエラー**
- サポートされている形式: JPEG, PNG
- 最大ファイルサイズの確認

**Gemini API エラー**
- APIキーの有効性を確認
- API利用制限の確認
- `raw_response`カラムでエラー詳細を確認

### デバッグ方法

```ruby
# Rails コンソールでサービスを直接実行
rails console
> GeminiService.analyze_business_card(BusinessCard.last.image)
```

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🤝 貢献

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチをプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📞 サポート

問題や質問がある場合は、GitHubのIssuesページで報告してください。

---

**注意**: 本アプリケーションは開発・学習目的で作成されています。本番環境での使用には追加のセキュリティ対策と機能強化が必要です。