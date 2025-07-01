# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Route, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }
  let(:route1) { map.locations[0].routes[0] }

  it 'initializes correctly' do
    expect(route1).to be_valid
  end

  pending 'should have a path of sequential, adjacent tile coords'

  pending 'should start adjacent to the first location and end adjacent to the second location'

  pending 'should properly reverse its path if the route is being travelled in reverse'

  describe 'Map Gen' do
    it 'generates the routes according to the story settings' do
      expect(map.routes.count).to eq(4)
    end
  end
end
