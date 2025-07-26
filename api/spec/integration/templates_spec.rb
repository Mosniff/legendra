# frozen_string_literal: true

require 'rails_helper'

GENERAL_TEMPLATES = TemplateLoader.load_templates('general_templates.yml').transform_keys(&:to_s).transform_values do |attrs|
  attrs['name']
end
STORY_TEMPLATES = TemplateLoader.load_templates('story_templates.yml')
SCENARIO_TEMPLATES = TemplateLoader.load_templates('scenario_templates.yml')
RSpec.describe 'Templates', type: :integration do
  STORY_TEMPLATES.each_key do |template_name|
    it "generates a valid world for template '#{template_name}'" do
      game = create(:game)
      world = game.world
      expect { world.select_story(template_name) }.not_to raise_error
      expect(game).to be_valid
      expect(world).to be_valid
      expect(world.map).to be_valid
      expect(world.kingdoms.where(is_player_kingdom: true).count).to eq(1)
      expect(world.player_kingdom).to be_valid
    end
    it "assigns generals to kingdoms correctly for template '#{template_name}'" do
      game = create(:game)
      world = game.world
      expect { world.select_story(template_name) }.not_to raise_error

      # scenario_template_key = Story.get_scenario_template_key(Story.templates[template_name])
      scenario_template_key = STORY_TEMPLATES[template_name][:scenario_template_key]
      scenario_template = SCENARIO_TEMPLATES[scenario_template_key.to_sym]

      (scenario_template['kingdoms'] || []).each do |kingdom_attrs|
        kingdom = world.kingdoms.find_by(name: kingdom_attrs['name'])
        expect(kingdom).to be_present

        general_keys = (kingdom_attrs['generals'] || []).map { |g| g['key'] || g[:key] }
        general_keys.each do |general_key|
          general_name = GENERAL_TEMPLATES[general_key.to_s]
          expect(
            kingdom.generals.find_by(name: general_name)
          ).to be_present, "Expected #{kingdom.name} to have general named #{general_name}"
        end
      end

      # Check independent generals
      (scenario_template['independent_generals'] || []).each do |general_ref|
        general_key = general_ref[:key]
        general_name = GENERAL_TEMPLATES[general_key.to_s]
        general = world.generals.find_by(name: general_name)
        expect(general).to be_present, "Expected independent general named #{general_name} to exist"
        expect(general.kingdom).to be_nil, "Expected independent general #{general_name} to not belong to any kingdom"
      end
    end
  end
end
