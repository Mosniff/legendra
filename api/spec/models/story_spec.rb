# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story, type: :model do
  let(:game) { create(:game) }
  let(:world) { game.world }
  it 'initializes correctly' do
    story = Story.build_from_template('test_story', world: world)

    expect(story).to be_valid
    expect(story).to be_a(Story)
    expect(story.world).to be_a(World)
    expect(story.game).to be_a(Game)
    expect(story.scenario).to be_a(Scenario)
  end
end
