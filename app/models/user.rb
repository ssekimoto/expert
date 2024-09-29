class User < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true
    scope :active, -> { where(active: true) } # 長期休暇中のユーザーをスキップするためにactiveフィールドを使用
end
  