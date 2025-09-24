require 'rails_helper'

RSpec.describe Battle, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:world) { game.world }
  let(:battle) do
    create(:battle, world: world, side_a: world.kingdoms.first, side_b: world.kingdoms.last,
                    tile: world.map.tiles.first, turn: 1)
  end
  let(:army1) do
    Army.spawn_with_generals(
      { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).first, x_coord: 0, y_coord: 0 },
      [General.create(world: world, kingdom: world.kingdoms.first)]
    )
  end
  let(:army2) do
    Army.spawn_with_generals(
      { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).last, x_coord: 0, y_coord: 0 },
      [General.create(world: world, kingdom: world.kingdoms.last)]
    )
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

  describe 'Resolving' do
    it 'must have two opposing armies to resolve' do
      expect do
        battle.resolve_battle(nil, nil)
      end.to raise_error(ArgumentError, 'Must have two opposing armies')
    end

    it 'both armies must be on the correct tile' do
      wrong_tile_army = Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).last, x_coord: 0, y_coord: 1 },
        [General.create(world: world, kingdom: world.kingdoms.last)]
      )
      expect do
        battle.resolve_battle(army1, wrong_tile_army)
      end.to raise_error(ArgumentError, 'Both armies must be on the battle tile')
    end
    it 'can have a winner' do
      battle.resolve_battle(army1, army2)
      expect(battle.state).to eq('completed')
      expect(battle.winner).to be_a(Kingdom)
      expect(battle.is_draw).to be(false)
    end

    it 'can be draw' do
      battle.resolve_battle(army1, army2, force_draw: true)
      expect(battle.state).to eq('completed')
      expect(battle.winner).to be_nil
      expect(battle.is_draw).to be(true)
    end

    it 'must not be completed without either a winner or being a draw' do
      skip 'Not implemented yet'
    end

    describe 'History' do
      it 'should take a snapshot of each team at the start' do
        skip 'Not implemented yet'
      end

      it 'should take a snapshot of each team each turn' do
        skip 'Not implemented yet'
      end

      it 'should take a snapshot of each team at the end' do
        skip 'Not implemented yet'
      end
    end
  end

  describe 'Retreating' do
    it 'should send an army in the middle of a route back the way it came' do
      skip 'Not implemented yet'
    end

    it 'should send an army at the start of its route ...' do
      skip 'Not implemented yet'
    end

    it 'should send a stationary army ...' do
      skip 'Not implemented yet'
    end

    it 'should send a fleeing garrison ...' do
      skip 'Not implemented yet'
    end
  end
end
