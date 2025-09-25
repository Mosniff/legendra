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
  let(:army3) do
    Army.spawn_with_generals(
      { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).last, x_coord: 4, y_coord: 4 },
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
      expect do
        battle.resolve_battle(army1, army3)
      end.to raise_error(ArgumentError, 'Both armies must be on the battle tile')
    end
    it 'can have a winner' do
      battle.resolve_battle(army1, army2)
      expect(battle.state).to eq('completed')
      expect(battle.winner).to be_a(Kingdom)
      expect(battle.is_draw).to be(false)
    end

    it 'can be a draw' do
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
      journey1 = army1.current_location.get_journey_to(army3.current_location)
      journey2 = army3.current_location.get_journey_to(army1.current_location)
      army1.assign_to_journey(journey1[:route], journey1[:direction])
      army3.assign_to_journey(journey2[:route], journey2[:direction])
      army1.advance_along_route
      army3.advance_along_route
      army1.advance_along_route
      expect(Battle.count).to eq(0)
      army1.reload
      army3.reload
      army3.advance_along_route
      expect(Battle.count).to eq(1)
      army1.reload
      army3.reload
      expect([army1.coords, army3.coords]).to include([2, 2])
      expect([army1.coords, army3.coords]).to include([1, 1]).or include([3, 3])
    end

    it 'should send an army at the start of its route randomly in some direction' do
      skip 'Not implemented yet'
    end

    it 'should send a stationary army randomly in some direction' do
      skip 'Not implemented yet'
    end

    it 'should send a fleeing garrison randomly in some direction' do
      skip 'Not implemented yet'
    end
  end
end
