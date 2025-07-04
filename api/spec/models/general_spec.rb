require 'rails_helper'

RSpec.describe General, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:general) { create(:general, world: game.world) }
  it 'initializes correctly' do
    expect(general).to be_valid
  end

  # Build a hash for quick lookup: { "general_1" => "General One", ... }
  general_templates = {}
  General.templates.each do |key, attrs|
    general_templates[key.to_s] = attrs['name']
  end

  Story.templates.each_key do |template_name|
    it "assigns generals to kingdoms correctly for template '#{template_name}'", :slow do
      game = create(:game)
      world = game.world
      expect { world.select_story(template_name) }.not_to raise_error

      scenario_template_key = Story.get_scenario_template_key(Story.templates[template_name])
      scenario_template = Scenario.templates[scenario_template_key]

      (scenario_template['kingdoms'] || []).each do |kingdom_attrs|
        kingdom = world.kingdoms.find_by(name: kingdom_attrs['name'])
        expect(kingdom).to be_present

        general_keys = (kingdom_attrs['generals'] || []).map { |g| g['key'] || g[:key] }
        general_keys.each do |general_key|
          general_name = general_templates[general_key.to_s]
          expect(
            kingdom.generals.find_by(name: general_name)
          ).to be_present, "Expected #{kingdom.name} to have general named #{general_name}"
        end
      end
    end
  end
end
