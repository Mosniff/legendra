# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { create(:user) }
  let(:game) { create(:game, user: user) }
  let(:game1) { create(:game, user: user, slot: 0, active: true) }
  let(:game2) { create(:game, user: user, slot: 1) }
  let(:game_with_story) { create(:game, :with_story) }

  describe 'Initialization:' do
    it 'initializes correctly' do
      expect(game).to be_valid
      expect(game.user).to be_a(User)

      expect(game.slot).to be_between(0, 9).inclusive
      expect(game.id).to eq(game.user.game_slots[game.slot].id)

      expect(game.game_state).to eq('story_choice')
      expect(game.active?).to be(false)

      expect(game.world).to be_a(World)
      expect(game.story).to be_nil
      expect(game.turn).to eq(1)
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

  describe 'Turns' do
    it 'can advance turn' do
      expect(game_with_story.turn).to eq(1)
      game_with_story.advance_turn
      expect(game_with_story.turn).to eq(2)
    end

    it 'should move armies for each kingdom along their routes' do
      world = game_with_story.world
      army1 = Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.first, x_coord: 0, y_coord: 0 },
        [General.create(world: world, kingdom: world.kingdoms.first)]
      )
      army2 = Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.last, x_coord: 4, y_coord: 4 },
        [General.create(world: world, kingdom: world.kingdoms.last)]
      )
      journey1 = army1.current_location.get_journey_to(army2.current_location)
      journey2 = army2.current_location.get_journey_to(army1.current_location)
      army1.assign_to_journey(journey1[:route], journey1[:direction])
      army2.assign_to_journey(journey2[:route], journey2[:direction])
      expect(army1.x_coord).to eq(0)
      expect(army1.y_coord).to eq(0)
      expect(army2.x_coord).to eq(4)
      expect(army2.y_coord).to eq(4)
      game_with_story.advance_turn
      army1.reload
      army2.reload
      expect(army1.x_coord).to eq(1)
      expect(army1.y_coord).to eq(1)
      expect(army2.x_coord).to eq(3)
      expect(army2.y_coord).to eq(3)
    end
  end
end
