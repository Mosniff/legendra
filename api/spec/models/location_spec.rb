require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }
  let(:location1) { map.get_tile(0, 0).location }
  let(:location2) { map.get_tile(4, 4).location }
  let(:location3) { map.get_tile(0, 2).location }

  it 'initializes correctly' do
    expect(location1).to be_valid
  end

  it 'should be able to grab all associated routes' do
    expect(location1.routes.length).to eq(2)
  end

  it 'should be able to grab all locations it has routes to' do
    expect(location1.connected_locations.length).to eq(2)
    expect(location1.connected_locations[0].locatable).to be_a(Town)
    expect(location1.connected_locations[1].locatable).to be_a(Castle)
  end

  it 'should be able to grab a route to a given location' do
    expect(location1.get_route_to(location3)).to be_a(Route)
  end

  describe 'Map Gen' do
    it 'generates the locations according to the story settings' do
      expect(location1).to be_a(Location)
      expect(location1.locatable).to be_a(Castle)
      expect(location1.locatable.name).to eq('Castle A')

      expect(location2).to be_a(Location)
      expect(location2.locatable).to be_a(Castle)
      expect(location2.locatable.name).to eq('Castle C')

      expect(location3).to be_a(Location)
      expect(location3.locatable).to be_a(Town)
      expect(location3.locatable.name).to eq('Town A')
    end
  end
end
