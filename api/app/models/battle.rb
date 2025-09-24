class Battle < ApplicationRecord
  belongs_to :world
  belongs_to :side_a, class_name: 'Kingdom', foreign_key: 'side_a_id'
  belongs_to :side_b, class_name: 'Kingdom', foreign_key: 'side_b_id'
  belongs_to :tile
  belongs_to :winner, class_name: 'Kingdom', optional: true

  BATTLE_STATES = %w[awaiting_resolution completed].freeze
  validates :state, inclusion: { in: BATTLE_STATES }

  def resolve_battle(army1, army2, force_draw: false)
    unless army1.is_a?(Army) && army2.is_a?(Army) && army1.kingdom != army2.kingdom
      raise ArgumentError, 'Must have two opposing armies'
    end

    raise ArgumentError, 'Both armies must be on the battle tile' unless army1.tile == tile && army2.tile == tile

    if force_draw
      self.is_draw = true
      self.winner = nil
    else
      self.winner = randomly_determine_winner(army1, army2)
    end
    update(state: 'completed')
  end

  def randomly_determine_winner(army1, army2)
    # TODO implement actual battle logic
    [army1, army2].sample.kingdom
  end
end
