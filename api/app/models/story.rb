# frozen_string_literal: true

class Story < ApplicationRecord
  belongs_to :world
  delegate :game, to: :world
  belongs_to :scenario

  def self.templates
    @templates ||= YAML.load_file(Rails.root.join('lib', 'game_content', 'story_templates.yml')).with_indifferent_access
  end

  def self.build_from_template(template_name, world:)
    attrs = templates[template_name]
    raise ArgumentError, "Unknown story template: #{template_name}" unless attrs

    scenario_template_key = attrs['scenario_template_key'] || attrs[:scenario_template_key]
    unless scenario_template_key
      raise ArgumentError,
            "Missing scenario_template_key in story template: #{template_name}"
    end

    scenario = Scenario.build_from_template(scenario_template_key)

    story_attrs = attrs.except('scenario_template_key', :scenario_template_key)
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
