class Battle < ApplicationRecord
  belongs_to :world
  belongs_to :side_a, class_name: 'Kingdom', foreign_key: 'side_a_id'
  belongs_to :side_b, class_name: 'Kingdom', foreign_key: 'side_b_id'
  belongs_to :tile
  belongs_to :winner, class_name: 'Kingdom', optional: true

  BATTLE_STATES = %w[awaiting_resolution completed].freeze
  validates :state, inclusion: { in: BATTLE_STATES }

  def resolve_battle(army1, army2, force_draw: false, forced_winner: nil)
    unless army1.is_a?(Army) && army2.is_a?(Army) && army1.kingdom != army2.kingdom
      raise ArgumentError, 'Must have two opposing armies'
    end

    raise ArgumentError, 'Both armies must be on the battle tile' unless army1.tile == tile && army2.tile == tile

    update(state: 'completed')
    if force_draw
      self.is_draw = true
      self.winner = nil
    elsif forced_winner
      winning_army = [army1, army2].find { |a| a.kingdom == forced_winner }
      losing_army = (winning_army == army1 ? army2 : army1)
      self.winner = winning_army.kingdom
      losing_army.retreat
    else
      winning_army = randomly_determine_winner(army1, army2)
      losing_army = (winning_army == army1 ? army2 : army1)
      self.winner = winning_army.kingdom
      losing_army.retreat
    end
    save!
  end

  def randomly_determine_winner(army1, army2)
    # TODO: implement actual battle logic
    [army1, army2].sample
  end
end
