# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:world) { game.world }
  let(:story) { world.story }
  it 'initializes correctly' do
    expect(story).to be_valid
    expect(story).to be_a(Story)
    expect(story.world).to be_a(World)
    expect(story.game).to be_a(Game)
    expect(story.scenario).to be_a(Scenario)
  end
end
