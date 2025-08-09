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
`render.yaml` で以下が自動付与されます：
- `RAILS_ENV=production`
- `RAILS_SERVE_STATIC_FILES=true`
- `RAILS_LOG_TO_STDOUT=true`
- `SECRET_KEY_BASE`（自動生成）

必要に応じてダッシュボードで `GEMINI_API_KEY` を追加してください。

### 3. デプロイ実行（最速起動）
1. "Deploy Blueprint" をクリック
2. ビルド（assets:precompile）後、`startCommand` で `db:migrate` が毎回自動実行され Rails が起動します
3. 初回は 5 分前後。完了後に公開 URL が発行されます

## 現在の blueprint 抜粋
```yaml
services:
	- type: web
		env: ruby
		buildCommand: "./bin/rails assets:precompile"
		startCommand: "./bin/rails db:migrate && ./bin/rails server"
		plan: free
		# SQLite は永続化されず再起動/再デプロイでデータ消える
```

## データベースについて（重要）
Free プランでは persistent disk が使えないため、SQLite ファイルはコンテナの一時領域に置かれ「再デプロイ / スリープ復帰」で消えます。

用途が「動作確認・デモ」の間はそのままで OK ですが、データ保持したい場合は PostgreSQL への移行を推奨します。

### PostgreSQL へ移行する流れ（概要）
1. Render で "New +" → PostgreSQL を作成（Free tier 可）
2. 接続文字列をコピーし Web Service の Environment に `DATABASE_URL` 追加
3. Gemfile を変更:
	 ```ruby
	 gem "pg"
	 gem "sqlite3", group: [:development, :test]
	 ```
4. `bundle install` → コミット & デプロイ
5. Render の Shell か Background Job で `rails db:migrate` 実行（startCommand からは `db:migrate` を削除するのが望ましい）
6. 正常動作を確認

※ 本格運用に進む前に必ずこの移行を行うこと。

## デプロイ後の確認

### ヘルスチェック
- `https://your-app.onrender.com/up` にアクセス
- "Rails is up and running" が表示されればOK

### アプリケーション動作確認
- ルートURL(`https://your-app.onrender.com`)で名刺読み取りページが表示

## 注意事項

### SQLite（揮発）使用時の制約（現状）
- データはデプロイ/リスタートごとに消える（persistent disk 未使用）
- 単一インスタンス前提（ロック・同時書き込み耐性が弱い）
- 商用利用不可。必ず PostgreSQL へ移行すること

### データベース初期化
`startCommand` に `db:migrate` が含まれているため、毎回最新スキーマに自動更新されます（揮発 DB 前提の割り切り）。
PostgreSQL に移行後は startCommand から `db:migrate` を外し、手動またはリリースフックで実行する形に改めてください。

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
2. ログでエラー詳細を確認
3. `db:migrate` が startCommand で失敗していないかログ検索（"Migrating" / エラー）

## 更新方法
1. Git にコードをプッシュ
2. Render が自動再デプロイ
3. 起動時に自動 migrate（揮発 DB）
4. 数分で反映

## よくある質問
Q. データが保持されません
→ 仕様です。PostgreSQL を導入してください。

Q. migrate が遅い/不要な気がする
→ 開発初期の利便性優先です。PostgreSQL 移行後に外します。

Q. Seed を入れたい
→ 一時的に startCommand を `./bin/rails db:migrate db:seed && ./bin/rails server` に変更し、デプロイ後元に戻す。