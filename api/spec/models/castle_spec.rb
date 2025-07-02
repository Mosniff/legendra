require 'rails_helper'

RSpec.describe Castle, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }

  it 'initializes correctly' do
    expect(map.castles.first).to be_valid
    expect(map.castles.first).to be_a(Castle)
  end
end
