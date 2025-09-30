class Clash < ApplicationRecord
  belongs_to :world
  belongs_to :tile
  belongs_to :game, optional: true
  belongs_to :forced_winner, class_name: 'Kingdom', optional: true

  has_one :side_a_army, class_name: 'Army', foreign_key: 'clash_id', dependent: :nullify
  has_one :side_b_army, class_name: 'Army', foreign_key: 'clash_id', dependent: :nullify

  def self.initiate_clash(army_a, army_b, tile, forced_winner: nil)
    clash = Clash.create!(world: army_a.world, tile: tile, forced_winner: forced_winner)
    clash.side_a_army = army_a
    clash.side_b_army = army_b
    clash.save!
    clash.attempt_to_resolve_clash
  end

  def attempt_to_resolve_clash(player_initiated: false)
    if !player_initiated && (side_a_army.kingdom.is_player_kingdom || side_b_army.kingdom.is_player_kingdom)
      world.game.update(game_state: 'awaiting_player', awaited_clash: self)
    else
      Battle.run_battle_from_clash(self)
    end
  end
end
