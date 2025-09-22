require 'rails_helper'

RSpec.describe Battle, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:battle) do
    create(:battle, world: game.world, side_a: game.world.kingdoms.first, side_b: game.world.kingdoms.last,
                    tile: game.world.map.tiles.first, turn: 1)
  end
  it 'initializes correctly' do
    expect(battle).to be_valid
    expect(battle.side_a).to be_a(Kingdom)
    expect(battle.side_b).to be_a(Kingdom)
    expect(battle.tile).to be_a(Tile)
    expect(battle.turn).to be_a(Integer)
    expect(battle.state).to eq('awaiting_resolution')
    expect(battle.is_draw).to be(false)
    expect(battle.winner).to be_nil
  end
end
