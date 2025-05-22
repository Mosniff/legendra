# frozen_string_literal: true

class Story < ApplicationRecord
  belongs_to :world
  delegate :game, to: :world

  def self.templates
    @templates ||= YAML.load_file(Rails.root.join('lib', 'game_content', 'story_templates.yml')).with_indifferent_access
  end

  def self.build_from_template(template_name, world:)
    attrs = templates[template_name]
    raise ArgumentError, "Unknown story template: #{template_name}" unless attrs

    new(attrs.merge(world: world))
  end
end
