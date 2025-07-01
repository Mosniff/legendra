# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tile, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }
  let(:first_tile) { map.get_tile(0, 0) }

  it 'initializes correctly' do
    expect(first_tile).to be_valid
  end

  pending 'can detect what routes it is a part of'

  pending 'knows if it is a route tile or not'

  describe 'Map Gen' do
    it 'generates the correct tiles according to the story settings' do
      expect(map.get_tile(0, 0).terrain).to eq('grassland')
      expect(map.get_tile(4, 4).terrain).to eq('snow')
    end
  end
end
