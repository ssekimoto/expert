# 初期ユーザーを作成
users = User.create!([
  { name: "山田 太郎", email: "yamada@example.com", active: true },
  { name: "佐藤 花子", email: "sato@example.com", active: true },
  { name: "鈴木 次郎", email: "suzuki@example.com", active: true },
  { name: "田中 三郎", email: "tanaka@example.com", active: true }
])

# 最初のローテーションを作成。最初の担当者を設定
Rotation.create!(current_user: users.first)

