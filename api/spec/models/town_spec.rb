require 'rails_helper'

RSpec.describe Town, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:map) { game.world.map }

  it 'initializes correctly' do
    expect(map.towns.first).to be_valid
    expect(map.towns.first).to be_a(Town)
  end
end
