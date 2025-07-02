# frozen_string_literal: true

class Scenario < ApplicationRecord
  has_one :story, dependent: :destroy

  def self.templates
    @templates ||= YAML.load_file(Rails.root.join('lib', 'game_content',
                                                  'scenario_templates.yml')).with_indifferent_access
  end

  def self.build_from_template(template_name)
    attrs = templates[template_name]
    raise ArgumentError, "Unknown scenario template: #{template_name}" unless attrs

    scenario_attrs = attrs.except('map_template_key', :map_template_key, 'kingdoms', :kingdoms)
    new(scenario_attrs)
  end
end
