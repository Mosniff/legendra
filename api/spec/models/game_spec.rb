require 'rails_helper'

RSpec.describe Game, type: :model do
  it 'should initialize correctly' do
    game = create(:game)
    expect(game).to be_valid
    expect(game.user).to be_a(User)

    expect(game.slot).to be_between(1, 10).inclusive
    expect(game.id).to eq(game.user.game_slots[game.slot - 1].id)
  end

  it 'does not allow more than 10 games per user' do
    user = create(:user)
    10.times { |i| create(:game, user: user, slot: i + 1) }
    expect { create(:game, user: user, slot: 1) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
