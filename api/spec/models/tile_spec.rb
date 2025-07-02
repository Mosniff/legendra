# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tile, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }

  it 'initializes correctly' do
    expect(map.get_tile(0, 0)).to be_valid
  end

  it 'can detect what routes it is a part of' do
    route = Route.find_by(
      location_a_id: map.get_tile(0, 0).location.id,
      location_b_id: map.get_tile(4, 4).location.id
    )
    expect(map.get_tile(2, 2).related_routes.length).to eq(1)
    expect(map.get_tile(2, 2).related_routes[0].id).to eq(route.id)
  end

  describe 'Map Gen' do
    it 'generates the correct tiles according to the story settings' do
      expect(map.get_tile(0, 0).terrain).to eq('grassland')
      expect(map.get_tile(4, 4).terrain).to eq('snow')
    end
  end
end
