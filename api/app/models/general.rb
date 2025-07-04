class General < ApplicationRecord
  belongs_to :world
  belongs_to :kingdom, optional: true

  def self.templates
    @templates ||= YAML.load_file(Rails.root.join('lib', 'game_content',
                                                  'general_templates.yml')).with_indifferent_access
  end

  def self.build_from_template(general_key, world:, kingdom: nil)
    general_attrs = General.templates[general_key]
    General.create!(general_attrs.merge(world: world, kingdom: kingdom))
  end
end
