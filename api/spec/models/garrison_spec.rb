require 'rails_helper'

RSpec.describe Garrison, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:garrison) { game.world.map.castles.first.garrison }
  let(:empty_garrison) { game.world.map.castles.last.garrison }
  it 'initializes correctly' do
    expect(garrison).to be_valid
  end

  it 'should have a count of generals' do
    expect(garrison.generals.count).to be_a(Integer)
  end

  it 'should allow generals to join and leave it' do
    expect(garrison.generals.count).to be(1)
    garrison.add_generals([game.world.generals[1]])
    expect(garrison.generals.count).to be(2)
    garrison.remove_general(game.world.generals[1])
    expect(garrison.generals.count).to be(1)
  end

  it 'should have a limit of 8 generals' do
    8.times do |_i|
      new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
      empty_garrison.add_generals([new_general])
    end
    new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
    expect do
      empty_garrison.add_generals([new_general])
    end.to raise_error(ArgumentError, 'Garrison already has 8 generals')
  end

  it 'should belong to a kingdom depending on assigned generals' do
    expect(empty_garrison.kingdom).to be_nil
    empty_garrison.add_generals([game.world.generals.first])
    expect(empty_garrison.kingdom).to eq(game.world.kingdoms.first)
    empty_garrison.remove_general(game.world.generals.first)
    expect(empty_garrison.kingdom).to be_nil
  end

  it 'should only allow generals of the correct kingdom' do
    new_general1 = General.create(world: game.world, kingdom: game.world.kingdoms.first)
    new_general2 = General.create(world: game.world, kingdom: game.world.kingdoms.last)
    garrison.add_generals([new_general1])
    expect do
      garrison.add_generals([new_general2])
    end.to raise_error(ArgumentError, 'Cannot add general from a different kingdom')
  end

  describe 'Army Interaction' do
    it 'should be able to create armies by giving away generals' do
      general1 = garrison.generals.first
      expect(garrison.generals.count).to be(1)
      expect(game.world.armies.count).to be(0)
      army = garrison.create_army([general1])
      expect(garrison.generals.count).to be(0)
      expect(game.world.armies.count).to be(1)
      expect(army.generals.count).to be(1)
      expect(army.generals.first.id).to be(general1.id)
    end

    it 'should be able to add to existing armies by giving away generals' do
      general1 = garrison.generals.first
      new_general1 = General.create(world: game.world, kingdom: game.world.kingdoms.first)
      garrison.add_generals([new_general1])
      new_general2 = General.create(world: game.world, kingdom: game.world.kingdoms.first)
      garrison.add_generals([new_general2])
      army = garrison.create_army([general1])
      expect(army.generals.count).to be(1)
      garrison.add_to_army(army, [new_general1, new_general2])
      expect(garrison.generals.count).to be(0)
      expect(army.generals.count).to be(3)
    end

    it 'should not allow creating armies if it would exceed the general limit' do
      5.times do |_i|
        new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
        garrison.add_generals([new_general])
      end
      expect(garrison.generals.count).to be(6)
      expect do
        garrison.create_army(garrison.generals)
      end.to raise_error(ArgumentError, 'Army already has 5 generals')
      expect(garrison.generals.count).to be(6)
    end

    it 'should not allow adding generals to existing armies if it would exceed the general limit' do
      5.times do |_i|
        new_general = General.create(world: game.world, kingdom: game.world.kingdoms.first)
        garrison.add_generals([new_general])
      end
      expect(garrison.generals.count).to be(6)
      army = garrison.create_army([garrison.generals.first])
      expect do
        garrison.add_to_army(army, garrison.generals)
      end.to raise_error(ArgumentError, 'Army already has 5 generals')
      expect(garrison.generals.count).to be(5)
    end

    it 'should not allow adding generals to armies if on different tiles' do
      army = Army.spawn_with_generals(
        { world: game.world, kingdom: game.world.kingdoms.first, x_coord: 1, y_coord: 1 },
        [
          General.create(world: game.world, kingdom: game.world.kingdoms.first)
        ]
      )
      expect do
        garrison.add_to_army(army, [garrison.generals.first])
      end.to raise_error(ArgumentError, 'Cannot add to army from a different tile')
    end
  end
end
