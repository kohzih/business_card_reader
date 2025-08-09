class GeminiService
  PROMPT = <<~PROMPT
    名刺の画像データを読み取ったテキストから次の情報を抽出してください。
    各項目は、括弧内のラベルで出力してください:
    - 氏名（苗字、名前を分けて抽出、full_name）
    - 会社名（日本語の場合は日本語で記載、company_name）
    - 部署（department）
    - 役職（「社長」、「部長」、「リーダー」、「マネージャー」など、post）
    - 電話番号（telephone_number）
    - メールアドレス（mail）
    - 住所（会社の住所、address）

    該当項目の情報がない場合は、空白で構いません。
    同じ情報が複数あると思われる場合は、より上部に書かれている方を優先してください。
    漢数字は半角の数字に変換してください。

    結果はJSON形式で返してください。
    例: {"full_name": "山田太郎", "company_name": "株式会社サンプル", "department": "営業部", "post": "部長", "telephone_number": "03-1234-5678", "mail": "yamada@sample.com", "address": "東京都渋谷区..."}
  PROMPT

  def self.analyze_business_card(image_attachment)
    return { success: false, error: "Image not found" } unless image_attachment.attached?

    begin
      # Configure Gemini client
      Gemini.configure do |config|
        config.access_token = Rails.application.credentials.google_api_key
      end

      client = Gemini::Client.new

      # 画像をbase64エンコード
      image_data = image_attachment.blob.download
      base64_image = Base64.strict_encode64(image_data)

      response = client.generate_content(
        parameters: {
          model: "gemini-2.5-flash",
          contents: [
            {
              parts: [
                { text: PROMPT },
                {
                  inline_data: {
                    mime_type: image_attachment.blob.content_type,
                    data: base64_image
                  }
                }
              ]
            }
          ]
        }
      )

      # レスポンスからJSONを抽出
      content_text = response.dig("candidates", 0, "content", "parts", 0, "text")

      if content_text
        # JSON部分を抽出（```json...```の場合もあるため）
        json_match = content_text.match(/\{.*\}/m)
        if json_match
          parsed_data = JSON.parse(json_match[0])
          return {
            success: true,
            data: parsed_data.merge(raw_response: content_text)
          }
        end
      end

      { success: false, error: "Failed to parse response", raw_response: content_text }

    rescue JSON::ParserError => e
      { success: false, error: "JSON parse error: #{e.message}", raw_response: content_text }
    rescue => e
      { success: false, error: "API error: #{e.message}" }
    end
  end
end
