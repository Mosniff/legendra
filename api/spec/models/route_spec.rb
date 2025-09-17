# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Route, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }
  let(:location_a) { map.locations[0] }
  let(:location_b) { map.locations[2] }
  let(:route) { location_a.routes[0] }

  it 'initializes correctly' do
    expect(route).to be_valid
  end

  describe 'Sad Path' do
    before do
      invalid_path = [[0, 4], [1, 3], [4, 0]]
      @bad_route = Route.new(
        location_a: location_a,
        location_b: location_b,
        path: invalid_path
      )
    end
    it 'should error if path is not sequential' do
      expect(@bad_route).not_to be_valid
      expect(@bad_route.errors[:path]).to include('must be sequential and adjacent (distance 1 between each step)')
    end

    it 'should error if it does not start adjacent to the first location ' do
      expect(@bad_route).not_to be_valid
      expect(@bad_route.errors[:path]).to include(
        'must link two locations (path must contain adjacent tiles to A and B)'
      )
    end
    it 'should error if it does not end adjacent to the second location' do
      expect(@bad_route).not_to be_valid
      expect(@bad_route.errors[:path]).to include(
        'must link two locations (path must contain adjacent tiles to A and B)'
      )
    end
  end

  describe 'Map Gen' do
    # Move to world gen tests
    it 'generates the routes according to the story settings' do
      expect(map.routes.count).to eq(4)
    end
  end
end
