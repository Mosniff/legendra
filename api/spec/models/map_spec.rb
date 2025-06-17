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
  end
end
