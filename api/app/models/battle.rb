class Battle < ApplicationRecord
  belongs_to :world
  belongs_to :side_a, class_name: 'Kingdom', foreign_key: 'side_a_id'
  belongs_to :side_b, class_name: 'Kingdom', foreign_key: 'side_b_id'
  belongs_to :tile
  belongs_to :winner, class_name: 'Kingdom', optional: true

  BATTLE_STATES = %w[awaiting_resolution completed].freeze
  validates :state, inclusion: { in: BATTLE_STATES }
end
