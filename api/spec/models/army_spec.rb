# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Army, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:army) do
    Army.spawn_with_generals(
      { world: game.world, kingdom: game.world.kingdoms.first, x_coord: 0, y_coord: 0 },
      [
        General.create(world: game.world, kingdom: game.world.kingdoms.first),
        General.create(world: game.world, kingdom: game.world.kingdoms.first),
        General.create(world: game.world, kingdom: game.world.kingdoms.first)
      ]
    )
  end

  it 'initializes correctly' do
    expect(army).to be_valid
    expect(army.generals.count).to be(3)
  end

  it 'should require a minimum of 1 general to create' do
    expect do
      Army.spawn_with_generals(
        { world: game.world, kingdom: game.world.kingdoms.first, x_coord: 0, y_coord: 0 },
        []
      )
    end.to raise_error(ArgumentError, 'Must have at least 1 general')
  end

  it 'should destroy itself if the general count reaches 0 after update' do
    3.times do
      army.remove_general(army.generals.first)
    end
    expect(Army.where(id: army.id)).to be_empty

    new_army = Army.spawn_with_generals(
      { world: game.world, kingdom: game.world.kingdoms.first, x_coord: 0, y_coord: 0 },
      [General.create(world: game.world, kingdom: game.world.kingdoms.first)]
    )
    new_army.generals.first.update(assignable: nil)
    expect(Army.where(id: new_army.id)).to be_empty
  end

  it 'should have a leader general' do
    skip 'Not implemented yet'
  end

  it 'should allow generals to join and leave it' do
    new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
    army.add_generals([new_general])
    expect(army.generals.count).to be(4)
    army.remove_general(new_general)
    expect(army.generals.count).to be(3)
  end

  it 'should only allow generals of that kingdom to join' do
    new_general = General.create(world: game.world, kingdom: game.world.kingdoms.last)
    expect do
      army.add_generals([new_general])
    end.to raise_error(ArgumentError, 'Cannot add general from a different kingdom')
  end

  it 'should have a limit of 5 generals' do
    2.times do |_i|
      new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
      army.add_generals([new_general])
    end
    new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
    expect do
      army.add_generals([new_general])
    end.to raise_error(ArgumentError, 'Army already has 5 generals')
  end

  describe 'Garrison Interaction' do
    it 'should be able to add to existing garrisons by giving away generals' do
      garrison = army.tile.castle.garrison
      expect(garrison.generals.count).to be(1)
      expect(army.generals.count).to be(3)
      army.add_to_garrison(garrison, [army.generals.first])
      expect(garrison.generals.count).to be(2)
      expect(army.generals.count).to be(2)
    end

    it 'should not allow adding generals to garrisons if it would exceed the garrison limit' do
      garrison = army.tile.castle.garrison
      expect(garrison.generals.count).to be(1)
      new_generals = []
      7.times do
        new_generals << General.create(world: game.world, kingdom: game.world.kingdoms.first)
      end
      garrison.add_generals(new_generals)
      expect(garrison.generals.count).to be(8)

      expect(army.generals.count).to be(3)
      expect(garrison.generals.count).to be(8)
      expect do
        army.add_to_garrison(garrison, [army.generals.first])
      end.to raise_error(ArgumentError, 'Garrison already has 8 generals')
      expect(army.generals.count).to be(3)
      expect(garrison.generals.count).to be(8)
    end

    it 'should not allow adding generals to garrisons if on different tiles' do
      garrison = army.tile.castle.garrison
      new_army = Army.spawn_with_generals(
        { world: game.world, kingdom: game.world.kingdoms.first, x_coord: 1, y_coord: 1 },
        [
          General.create(world: game.world, kingdom: game.world.kingdoms.first)
        ]
      )
      expect do
        new_army.add_to_garrison(garrison, [new_army.generals.first])
      end.to raise_error(ArgumentError, 'Cannot add to garrison from a different tile')
    end
  end

  describe 'Movement & Location' do
    it 'should be able to move to a new tile' do
      expect(army.x_coord).to be(0)
      expect(army.y_coord).to be(0)
      army.send(:move_to, 1, 1)
      expect(army.x_coord).to be(1)
      expect(army.y_coord).to be(1)
    end

    it 'should only be able to move to tiles 1 tile away' do
      expect do
        army.send(:move_to, 2, 2)
      end.to raise_error(ArgumentError, 'Can only move to adjacent tiles')
    end

    it 'should be able to be assigned a route starting on the same tile' do
      expect(army.currently_traveling_route).to be_nil
      route = army.current_location.get_route_to(army.current_location.connected_locations.first)
      army.assign_to_route(route)
      expect(army.currently_traveling_route).to be(route)
    end

    it 'should not be able to be assigned a route starting on a different tile' do
      route = Route.where.not(location_a: army.current_location).where.not(location_b: army.current_location).first
      expect do
        army.assign_to_route(route)
      end.to raise_error(ArgumentError, 'Route must start on the same tile as the army')
    end

    it 'should be able to move along routes' do
      route = army.current_location.get_route_to(army.current_location.connected_locations.first)
      army.assign_to_route(route)
      expect(army.x_coord).to be(route.location_a.tile.x_coord)
      expect(army.y_coord).to be(route.location_a.tile.y_coord)
      army.advance_along_route
      expect(army.x_coord).to be(route.path[0][0])
      expect(army.y_coord).to be(route.path[0][1])
    end

    it 'should unassign route when it reaches the destination' do
      route = army.current_location.get_route_to(army.current_location.connected_locations.first)
      army.assign_to_route(route)
      destination_coords = [route.location_b.tile.x_coord, route.location_b.tile.y_coord]
      army.currently_traveling_route.path.length.times do
        army.advance_along_route
      end
      expect(army.currently_traveling_route).to be(route)
      army.advance_along_route
      expect(army.currently_traveling_route).to be_nil
      expect(army.x_coord).to eq(destination_coords[0])
      expect(army.y_coord).to eq(destination_coords[1])
    end
  end
end
