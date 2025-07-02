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

  Story.templates.each_key do |template_name|
    it "generates a valid world for template '#{template_name}'", :slow do
      game = create(:game)
      world = game.world
      expect { world.select_story(template_name) }.not_to raise_error
      expect(game).to be_valid
      expect(world).to be_valid
      expect(world.map).to be_valid
      expect(world.kingdoms.where(is_player_kingdom: true).count).to eq(1)
      expect(world.player_kingdom).to be_valid
    end
  end
end
