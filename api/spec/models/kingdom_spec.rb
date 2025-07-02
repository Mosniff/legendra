require 'rails_helper'

RSpec.describe Kingdom, type: :model do
  let(:game) { create(:game, :with_story) }
  it 'initializes correctly' do
    expect(game.world.kingdoms.count).to eq(3)
    expect(game.world.kingdoms.first).to be_valid
  end

  it 'should error if two kingdoms are set as player kingdom' do
    expect(game.world.player_kingdom).to be_a(Kingdom)
    expect do
      Kingdom.find_by(is_player_kingdom: false).update!(is_player_kingdom: true)
    end.to raise_error(ActiveRecord::RecordInvalid, /player kingdom already exists/i)
  end
end
