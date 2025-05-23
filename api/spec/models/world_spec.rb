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
  end
end
