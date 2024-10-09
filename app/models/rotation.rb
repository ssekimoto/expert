class Rotation
  attr_accessor :id, :current_user_id

  def initialize(id:, current_user_id:)
    @id = id
    @current_user_id = current_user_id
  end

  # Firestore から指定 ID のローテーションを取得
  def self.find(id)
    doc = FirebaseFirestore.col("rotations").doc(id).get
    return nil unless doc.exists?

    data = doc.data
    new(id: doc.document_id, current_user_id: data[:current_user_id])
  end

  # 次の担当者を選ぶロジック
  def next_user
    users = User.active
    current_user = users.find { |user| user.id == current_user_id }
    current_index = users.index(current_user)
    next_index = (current_index + 1) % users.size
    users[next_index]
  end

  # 担当者を更新する
  def rotate!
    self.current_user_id = next_user.id
    save!
  end

  # Firestore にローテーションを保存
  def save!
    FirebaseFirestore.col("rotations").doc(id || SecureRandom.uuid).set({
      current_user_id: current_user_id,
      updated_at: Time.current
    }, merge: true)
  end
end
