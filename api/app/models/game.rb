class Game < ApplicationRecord
  belongs_to :user

  validates :slot, presence: true, inclusion: { in: 0..9 }
  validates :slot, uniqueness: { scope: :user_id }

  GAME_STATES = %w[world_gen playing paused finished lost].freeze
  validates :game_state, inclusion: { in: GAME_STATES }

  has_one :world, dependent: :destroy
  after_create :create_world

  private

  def create_world
    World.create!(game: self)
  end
end
