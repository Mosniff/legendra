# frozen_string_literal: true

require 'rails_helper'

GENERAL_TEMPLATES = TemplateLoader.load_templates('general_templates.yml')
STORY_TEMPLATES = TemplateLoader.load_templates('story_templates.yml')
SCENARIO_TEMPLATES = TemplateLoader.load_templates('scenario_templates.yml')
MAP_TEMPLATES = TemplateLoader.load_templates('map_templates.yml')
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
    it "creates the correct number of castles and towns for template '#{template_name}'" do
      # just check the counts
    end
    it "correctly populates the garrisons for template '#{template_name}'" do
      game = create(:game)
      world = game.world
      expect { world.select_story(template_name) }.not_to raise_error
      map = world.map

      scenario_template_key = STORY_TEMPLATES[template_name][:scenario_template_key]
      scenario_template = SCENARIO_TEMPLATES[scenario_template_key.to_sym]

      expected_garrison_counts = Hash.new(0)
      (scenario_template[:kingdoms] || []).each do |kingdom_attrs|
        kingdom_attrs[:generals].each do |general_ref|
          next unless general_ref[:starting_castle]

          castle_name = general_ref[:starting_castle]
          general_key = general_ref[:key]
          general_name = GENERAL_TEMPLATES[general_key.to_sym][:name]
          general = world.generals.find_by(name: general_name)
          expected_castle = map.castles.find_by(name: castle_name)
          expect(expected_castle.garrison.generals).to include(general)
          expected_garrison_counts[castle_name] += 1
        end
      end

      map_template_key = scenario_template[:map_template_key]
      map_template = MAP_TEMPLATES[map_template_key.to_sym]
      map_template[:width].times do |x|
        map_template[:height].times do |y|
          tile_settings = map_template[:tiles][:rows][x][y]
          next unless tile_settings[:location] && tile_settings[:location][:type] == 'Castle'

          castle_name = tile_settings[:location][:name]
          expected_count = expected_garrison_counts[castle_name] || 0
          actual_count = map.castles.find_by(name: castle_name).garrison.generals.count
          expect(actual_count).to eq(expected_count)
        end
      end
    end
  end
end
