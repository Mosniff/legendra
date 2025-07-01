# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Route, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }
  let(:route1) { map.locations[0].routes[0] }
  let(:route2) { map.locations[0].routes[1] }

  it 'initializes correctly' do
    expect(route1).to be_valid
  end

  it 'should error if path is not sequential' do
    location_a = map.locations.first
    location_b = map.locations.second
    invalid_path = [[0, 0], [0, 2]]

    route = Route.new(
      location_a: location_a,
      location_b: location_b,
      path: invalid_path
    )

    expect(route).not_to be_valid
    expect(route.errors[:path]).to include('must be sequential and adjacent (distance 1 between each step)')
  end

  pending 'should start adjacent to the first location and end adjacent to the second location'

  pending 'should properly reverse its path if the route is being travelled in reverse'

  describe 'Map Gen' do
    it 'generates the routes according to the story settings' do
      expect(map.routes.count).to eq(4)
    end
  end
end
