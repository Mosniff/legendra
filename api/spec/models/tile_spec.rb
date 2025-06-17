require 'rails_helper'

RSpec.describe Tile, type: :model do
  let(:game) { create(:game) }
  let(:world) { game.world }
  let(:map) { world.map }
  let(:first_tile) { map.get_tile(0, 0) }

  before do
    world.select_story('test_story')
  end

  it 'initializes correctly' do
    expect(first_tile).to be_valid
  end
end
