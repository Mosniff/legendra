# frozen_string_literal: true

require 'rails_helper'

RSpec.describe World, type: :model do
  let(:game) { create(:game) }
  let(:world) { game.world }

  it 'initializes correctly' do
    expect(world).to be_valid
    expect(world.game).to be_a(Game)
    expect(world.story).to be_nil
  end

  describe 'World Gen & Story:' do
    it 'can assign a story to itself' do
      expect(world.story).to be_nil
      world.select_story('test_story')
      expect(world.story).to be_a(Story)
    end

    it 'progresses the game state when story is assigned' do
      expect(game.game_state).to eq('story_choice')
      world.select_story('test_story')
      game.reload
      expect(game.game_state).to_not eq('story_choice')
    end

    it 'can only assign story whilst in the correct game_state' do
      world.select_story('test_story')
      expect(game.game_state).to eq('in_progress')
      expect do
        world.select_story('test_story')
      end.to raise_error(RuntimeError, 'Game state must be story_choice to assign a story.')
    end

    it 'will build a map after story is selected' do
      expect(world.map).to be_nil
      world.select_story('test_story')
      expect(world.map).to be_a(Map)
    end
  end
end
