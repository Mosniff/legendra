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
      world.assign_story_from_template(Story.templates.keys.first)
      expect(world.story).to be_a(Story)
    end

    it 'progresses the game state when story is assigned' do
      expect(game.game_state).to eq('story_choice')
      world.assign_story_from_template(Story.templates.keys.first)
      expect(game.game_state).to eq('world_gen')
    end

    it 'can only assign story in the correct game_state' do
      world.assign_story_from_template(Story.templates.keys.first)
      expect(game.game_state).to eq('world_gen')
      expect do
        world.assign_story_from_template(Story.templates.keys.first)
      end.to raise_error(RuntimeError, 'Game state must be story_choice to assign a story.')
    end
  end
end
