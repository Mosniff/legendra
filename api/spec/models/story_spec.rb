# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story, type: :model do
  it 'initializes correctly' do
    world = create(:game).world
    story = Story.build_from_template('test_story', world: world)

    expect(story).to be_valid
    expect(story).to be_a(Story)
    expect(story.world).to be_a(World)
    expect(story.game).to be_a(Game)
    expect(story.scenario).to be_a(Scenario)
  end
end
