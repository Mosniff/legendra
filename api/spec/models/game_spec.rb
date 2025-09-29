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
      game_with_story.attempt_advance_turn
      expect(game_with_story.turn).to eq(2)
      expect(game_with_story.game_state).to eq('orders_phase')
    end

    it 'can set which armies need to move' do
      world = game_with_story.world
      army1 = Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.first, x_coord: 0, y_coord: 0 },
        [General.create(world: world, kingdom: world.kingdoms.first)]
      )
      journey1 = army1.current_location.get_journey_to(Location.get_location_at(4, 4))
      army1.assign_to_journey(journey1)

      expect(world.armies_to_move.count).to eq(0)

      game_with_story.world.set_armies_to_move

      expect(world.armies_to_move.count).to eq(1)
      expect(world.armies_to_move.first).to be_a(Army)
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
      army1.assign_to_journey(journey1)
      army2.assign_to_journey(journey2)
      expect(army1.x_coord).to eq(0)
      expect(army1.y_coord).to eq(0)
      expect(army2.x_coord).to eq(4)
      expect(army2.y_coord).to eq(4)
      game_with_story.attempt_advance_turn
      army1.reload
      army2.reload
      expect(army1.x_coord).to eq(1)
      expect(army1.y_coord).to eq(1)
      expect(army2.x_coord).to eq(3)
      expect(army2.y_coord).to eq(3)
      expect(game_with_story.game_state).to eq('orders_phase')
      expect(game_with_story.turn).to eq(2)
    end

    it 'should make AI armies have a battle if they meet' do
      world = game_with_story.world
      army1 = Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).first, x_coord: 0, y_coord: 0 },
        [General.create(world: world, kingdom: world.kingdoms.first)]
      )
      army2 = Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).last, x_coord: 0, y_coord: 2 },
        [General.create(world: world, kingdom: world.kingdoms.last)]
      )
      journey1 = army1.current_location.get_journey_to(army2.current_location)
      journey2 = army2.current_location.get_journey_to(army1.current_location)
      army1.assign_to_journey(journey1)
      army2.assign_to_journey(journey2)
      expect(world.battles.count).to eq(0)
      game_with_story.attempt_advance_turn
      expect(world.battles.count).to eq(1)
      expect(world.battles.where(state: 'completed').count).to eq(1)
    end

    it 'should clash with multiple armies sequentially if stacked on a tile' do
      world = game_with_story.world
      army1 = Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).first, x_coord: 0, y_coord: 0 },
        [General.create(world: world, kingdom: world.kingdoms.first)]
      )
      Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).first, x_coord: 0, y_coord: 0 },
        [General.create(world: world, kingdom: world.kingdoms.first)]
      )
      army3 = Army.spawn_with_generals(
        { world: world, kingdom: world.kingdoms.where(is_player_kingdom: false).last, x_coord: 0, y_coord: 2 },
        [General.create(world: world, kingdom: world.kingdoms.last)]
      )
      journey = army3.current_location.get_journey_to(army1.current_location)
      army3.assign_to_journey(journey)
      expect(world.battles.count).to eq(0)
      army3.advance_along_route
      army3.advance_along_route(forced_winner: army3.kingdom)
      expect(world.battles.count).to eq(2)
    end

    it 'should pause turn resolution when player input is required' do
      world = game_with_story.world
      player_kingdom = world.player_kingdom
      ai_kingdom = world.kingdoms.where(is_player_kingdom: false).first
      army1 = Army.spawn_with_generals(
        { world: world, kingdom: ai_kingdom, x_coord: 0, y_coord: 0 },
        [General.create(world: world, kingdom: ai_kingdom)]
      )
      army2 = Army.spawn_with_generals(
        { world: world, kingdom: player_kingdom, x_coord: 0, y_coord: 2 },
        [General.create(world: world, kingdom: player_kingdom)]
      )
      journey1 = army1.current_location.get_journey_to(army2.current_location)
      journey2 = army2.current_location.get_journey_to(army1.current_location)
      army1.assign_to_journey(journey1)
      army2.assign_to_journey(journey2)

      expect(game_with_story.turn).to eq(1)
      expect(game_with_story.game_state).to eq('orders_phase')
      game_with_story.attempt_advance_turn
      expect(game_with_story.game_state).to eq('awaiting_player')
      expect(game_with_story.turn).to eq(1)
    end
  end
end
