class Game < ApplicationRecord
  belongs_to :user

  validates :slot, presence: true, inclusion: { in: 1..10 }
  validates :slot, uniqueness: { scope: :user_id }
end
