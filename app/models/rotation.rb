class Rotation < ApplicationRecord
  belongs_to :current_user, class_name: 'User', optional: true

  # 次の担当者を選ぶロジック
  def next_user
    users = User.active.to_a
    current_index = users.index(current_user)
    next_index = (current_index + 1) % users.size
    users[next_index]
  end

  # 担当者を更新する
  def rotate!
    self.current_user = next_user
    save!
  end
end
