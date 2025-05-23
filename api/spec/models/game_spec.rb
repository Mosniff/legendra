# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { create(:user) }
  let(:game1) { create(:game, user: user, slot: 0, active: true) }
  let(:game2) { create(:game, user: user, slot: 1) }

  describe 'Initialization:' do
    it 'initializes correctly' do
      game = create(:game)
      expect(game).to be_valid
      expect(game.user).to be_a(User)

      expect(game.slot).to be_between(0, 9).inclusive
      expect(game.id).to eq(game.user.game_slots[game.slot].id)

      expect(game.game_state).to eq('story_choice')
      expect(game.active?).to be(false)

      expect(game.world).to be_a(World)
      expect(game.story).to be_nil
    end

    it 'does not allow invalid values' do
      game = build(:game, game_state: 'invalid_state')
      expect(game).not_to be_valid

      game = build(:game, slot: 10)
      expect(game).not_to be_valid
    end
  end

  describe 'User Slots & Active Game:' do
    it 'does not allow more than 10 games per user' do
      user = create(:user)
      10.times { |i| create(:game, user: user, slot: i) }
      expect { create(:game, user: user, slot: 1) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'only allows one active game per user at a time' do
      expect(game1.active?).to be(true)
      expect(game2.active?).to be(false)

      game2.update(active: true)
      game1.reload

      expect(game1.active?).to be(false)
      expect(game2.active?).to be(true)
    end
  end
end
