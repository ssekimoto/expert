require 'google/cloud/firestore'

firestore = Google::Cloud::Firestore.new

# ユーザーコレクションに初期データを追加
users_data = [
  { name: "山田 太郎", email: "yamada@example.com", active: true },
  { name: "佐藤 花子", email: "sato@example.com", active: true },
  { name: "鈴木 次郎", email: "suzuki@example.com", active: true },
  { name: "田中 三郎", email: "tanaka@example.com", active: true }
]

user_ids = []
users_data.each do |user_data|
  doc_ref = firestore.col("users").add(user_data)
  user_ids << doc_ref.document_id
end

# 最初のローテーションを作成し、最初の担当者を設定
firestore.col("rotations").add({
  current_user_id: user_ids.first,
  created_at: Time.now,
  updated_at: Time.now
})
