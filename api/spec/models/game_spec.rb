require 'rails_helper'

RSpec.describe Game, type: :model do
  it 'should initialize correctly' do
    game = create(:game)
    expect(game).to be_valid
    expect(game.user).to be_a(User)

    expect(game.slot).to be_between(0, 9).inclusive
    expect(game.id).to eq(game.user.game_slots[game.slot].id)

    expect(game.game_state).to eq('world_gen')
  end

  it 'does not allow invalid values' do
    game = build(:game, game_state: 'invalid_state')
    expect(game).not_to be_valid

    game = build(:game, slot: 10)
    expect(game).not_to be_valid
  end

  it 'does not allow more than 10 games per user' do
    user = create(:user)
    10.times { |i| create(:game, user: user, slot: i) }
    expect { create(:game, user: user, slot: 1) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
