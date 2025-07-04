# frozen_string_literal: true

class Story < ApplicationRecord
  belongs_to :world
  delegate :game, to: :world
  belongs_to :scenario

  def self.templates
    @templates ||= YAML.load_file(Rails.root.join('lib', 'game_content', 'story_templates.yml')).with_indifferent_access
  end

  def self.get_scenario_template_key(story_attrs)
    scenario_template_key = story_attrs['scenario_template_key'] || story_attrs[:scenario_template_key]
    unless scenario_template_key
      raise ArgumentError,
            "Missing scenario_template_key in story template: #{template_name}"
    end
    scenario_template_key
  end

  def self.build_from_template(template_name, world:)
    attrs = templates[template_name]
    raise ArgumentError, "Unknown story template: #{template_name}" unless attrs

    scenario_template_key = get_scenario_template_key(attrs)
    scenario = Scenario.build_from_template(scenario_template_key)
    scenario_data = Scenario.templates[scenario_template_key]

    kingdoms_data =
      scenario_data['kingdoms'] ||
      scenario_data[:kingdoms] || []
    kingdoms_data.map do |kingdom_attrs|
      is_player_kingdom = kingdom_attrs['key'] == attrs['player_kingdom_key']
      kingdom = Kingdom.create!(kingdom_attrs.except(
        'key', :key,
        'generals', :generals
      ).merge(world: world, is_player_kingdom: is_player_kingdom))

      # Create generals for this kingdom
      (kingdom_attrs['generals'] || []).each do |general_ref|
        general_key = general_ref['key'] || general_ref[:key]
        general_attrs = General.templates[general_key]
        General.create!(general_attrs.merge(world: world, kingdom: kingdom))
      end
    end

    # Create independent generals (not assigned to any kingdom)
    (scenario_data['independent_generals'] || []).each do |general_ref|
      general_key = general_ref['key'] || general_ref[:key]
      general_attrs = General.templates[general_key]
      General.create!(general_attrs.merge(world: world, kingdom: nil))
    end

    story_attrs = attrs.except('scenario_template_key', :scenario_template_key, 'player_kingdom_key',
                               :player_kingdom_key)
    new(story_attrs.merge(world: world, scenario: scenario))
  end

  def self.get_map_key_from_story(template_name)
    attrs = templates[template_name]
    raise ArgumentError, "Unknown story template: #{template_name}" unless attrs

    scenario_template_key = attrs['scenario_template_key'] || attrs[:scenario_template_key]
    unless scenario_template_key
      raise ArgumentError,
            "Missing scenario_template_key in story template: #{template_name}"
    end

    Scenario.templates[scenario_template_key]['map_template_key']
  end
end
