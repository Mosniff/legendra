# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Map, type: :model do
  let(:game) { create(:game) }
  let(:world) { game.world }
  let(:map) { world.map }

  before do
    world.select_story('test_story')
  end
  it 'initializes correctly' do
    expect(map).to be_valid
  end

  it 'should be able to get tiles' do
    expect(map.get_tile(0, 0)).to be_a(Tile)
  end

  describe 'Map Gen' do
    it 'generates the correct tiles according to the story settings' do
      expect(map.get_tile(0, 0).terrain).to eq('grassland')
      expect(map.get_tile(4, 4).terrain).to eq('snow')
    end

    it 'generates the locations according to the story settings' do
      location1 = map.get_tile(0, 0).location
      expect(location1).to be_a(Location)
      expect(location1.locatable).to be_a(Castle)
      expect(location1.locatable.name).to eq('Castle A')

      location2 = map.get_tile(4, 4).location
      expect(location2).to be_a(Location)
      expect(location2.locatable).to be_a(Castle)
      expect(location2.locatable.name).to eq('Castle C')

      location3 = map.get_tile(0, 2).location
      expect(location3).to be_a(Location)
      expect(location3.locatable).to be_a(Town)
      expect(location3.locatable.name).to eq('Town A')
    end
  end
end
