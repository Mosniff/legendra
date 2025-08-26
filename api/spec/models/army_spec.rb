# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Army, type: :model do
  let(:game) { create(:game, :with_story) }
  # TODO: Create armies in world generation
  # let(:army) { game.world.armies.first }
  # let(:army) { Army.create!(world: game.world, kingdom: game.world.kingdoms.first, x_coord: 0, y_coord: 0) }
  let(:army) do
    Army.create_with_generals(
      { world: game.world, kingdom: game.world.kingdoms.first, x_coord: 0, y_coord: 0 },
      [game.world.generals.first]
    )
  end

  it 'initializes correctly' do
    expect(army).to be_valid
  end

  it 'should have a count of generals' do
    expect(army.generals.count).to be(1)
  end

  it 'should require a minimum of 1 general to create' do
    expect do
      Army.create_with_generals(
        { world: game.world, kingdom: game.world.kingdoms.first, x_coord: 0, y_coord: 0 },
        []
      )
    end.to raise_error(ArgumentError, 'Must have at least 1 general')
  end

  it 'should destroy itself if the general count reaches 0 after update' do
    army.generals.delete(army.generals.first)
    expect { army.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should have a leader general' do
    skip 'Not implemented yet'
  end

  it 'should allow generals to join and leave it' do
    new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
    army.add_general(new_general)
    expect(army.generals.count).to be(2)
    army.remove_general(new_general)
    expect(army.generals.count).to be(1)
  end

  it 'should only allow generals of that kingdom to join' do
    new_general = General.create(world: game.world, kingdom: game.world.kingdoms.last)
    expect do
      army.add_general(new_general)
    end.to raise_error(ArgumentError, 'Cannot add general from a different kingdom')
  end

  it 'should have a limit of 5 generals' do
    4.times do |_i|
      new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
      army.add_general(new_general)
    end
    new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
    expect do
      army.add_general(new_general)
    end.to raise_error(ArgumentError, 'Army already has 5 generals')
  end

  describe 'Movement' do
    it 'should be able to get its tile from its coordinates' do
      skip 'Not implemented yet'
    end

    it 'should be able to move to a new tile' do
      skip 'Not implemented yet'
    end

    it 'should only be able to move to tiles 1 tile away' do
      skip 'Not implemented yet'
    end
  end
end
