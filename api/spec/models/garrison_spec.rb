require 'rails_helper'

RSpec.describe Garrison, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:garrison) { game.world.map.castles.first.garrison }
  it 'initializes correctly' do
    expect(garrison).to be_valid
  end

  it 'should have a count of generals' do
    expect(garrison.generals.count).to be_a(Integer)
  end

  it 'should allow generals to join and leave it' do
    expect(garrison.generals.count).to be(0)
    garrison.add_general(game.world.generals.first)
    expect(garrison.generals.count).to be(1)
    garrison.remove_general(game.world.generals.first)
    expect(garrison.generals.count).to be(0)
  end

  it 'should have a limit of 8 generals' do
    8.times do |_i|
      new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
      garrison.add_general(new_general)
    end
    new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
    expect do
      garrison.add_general(new_general)
    end.to raise_error(ArgumentError, 'Garrison already has 8 generals')
  end

  it 'should belong to a kingdom depending on assigned generals' do
    expect(garrison.kingdom).to be_nil
    garrison.add_general(game.world.generals.first)
    expect(garrison.kingdom).to eq(game.world.kingdoms.first)
    garrison.remove_general(game.world.generals.first)
    expect(garrison.kingdom).to be_nil
  end

  it 'should only allow generals of the correct kingdom' do
    new_general1 = General.create(world: game.world, kingdom: game.world.kingdoms.first)
    new_general2 = General.create(world: game.world, kingdom: game.world.kingdoms.last)
    garrison.add_general(new_general1)
    expect do
      garrison.add_general(new_general2)
    end.to raise_error(ArgumentError, 'Cannot add general from a different kingdom')
  end

  it 'should be populated by an army joining an empty castle' do
    skip 'Not implemented yet'
  end

  it 'should be able to create armies by giving away generals' do
    skip 'Not implemented yet'
  end
end
