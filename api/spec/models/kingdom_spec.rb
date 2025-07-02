require 'rails_helper'

RSpec.describe Kingdom, type: :model do
  let(:game) { create(:game, :with_story) }
  it 'initializes correctly' do
    expect(game.world.kingdoms.count).to eq(3)
    expect(game.world.kingdoms.first).to be_valid
  end
end
