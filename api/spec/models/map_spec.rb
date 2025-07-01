# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Map, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }

  it 'initializes correctly' do
    expect(map).to be_valid
  end

  it 'should be able to get tiles' do
    expect(map.get_tile(0, 0)).to be_a(Tile)
  end

  describe 'Map Gen' do
    it 'generates with height and width' do
      expect(map.height).to eq(5)
      expect(map.width).to eq(5)
    end
  end

  pending 'test every template generates a valid with no errors, tag as slow'
end
