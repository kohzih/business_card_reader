# Render.com デプロイ手順

## 前提条件
- GitHubにコードをプッシュ済み
- Render.comアカウント作成済み

## デプロイ手順

### 1. Renderダッシュボードでサービス作成
1. [Render.com](https://render.com) にログイン
2. "New +" → "Blueprint" を選択
3. GitHubリポジトリを接続
4. `render.yaml`が自動検出される

### 2. 環境変数設定（自動設定済み）
以下の環境変数が`render.yaml`で自動設定されます：
- `RAILS_ENV=production`
- `RAILS_SERVE_STATIC_FILES=true`
- `RAILS_LOG_TO_STDOUT=true`
- `SECRET_KEY_BASE`（自動生成）

### 3. 永続ディスク設定
SQLiteデータベース用に1GBの永続ディスクが自動設定されます：
- マウントパス: `/opt/render/project/src/storage`
- データベースファイルが保存される

### 4. デプロイ実行
1. "Deploy Blueprint" ボタンをクリック
2. 初回デプロイには5-10分程度かかります
3. デプロイ完了後、URLが発行される

## デプロイ後の確認

### ヘルスチェック
- `https://your-app.onrender.com/up` にアクセス
- "Rails is up and running" が表示されればOK

### アプリケーション動作確認
- ルートURL(`https://your-app.onrender.com`)で名刺読み取りページが表示

## 注意事項

### SQLite使用時の制約
- **ゼロダウンタイムデプロイなし**: 更新時にアプリが一時停止
- **単一インスタンスのみ**: スケールアウト不可
- **個人学習用途**: 商用利用には PostgreSQL を推奨

### データベース初期化
初回デプロイ時は空のデータベースが作成されます。

### Gemini API設定
名刺読み取り機能を使用する場合：
1. Environment Variables に `GEMINI_API_KEY` を追加
2. Google AI Studio で API キーを取得して設定

## トラブルシューティング

### デプロイ失敗時
1. Render のログを確認
2. `bundle install` エラー → Gemfile.lock を更新
3. アセットコンパイルエラー → `bin/rails assets:precompile` をローカルで実行

### アプリ起動しない場合
1. 環境変数の設定確認
2. データベースマイグレーション状況確認
3. ログでエラー詳細を確認

## 更新方法
1. Gitにコードをプッシュ
2. Render が自動的に再デプロイ実行
3. 数分でデプロイ完了