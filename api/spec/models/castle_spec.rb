require 'rails_helper'

RSpec.describe Castle, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }
  let(:castle) { map.castles.first }

  it 'initializes correctly' do
    expect(castle).to be_valid
    expect(castle).to be_a(Castle)
  end

  it 'should have a garrison' do
    expect(castle.garrison).to be_a(Garrison)
  end

  it 'should count as empty if garrison has 0 generals' do
    expect(castle.empty?).to be true
    castle.garrison.add_general(game.world.generals.first)
    expect(castle.empty?).to be false
    castle.garrison.remove_general(game.world.generals.first)
    expect(castle.empty?).to be true
  end
end
