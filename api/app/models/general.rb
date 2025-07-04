class General < ApplicationRecord
  belongs_to :world
  belongs_to :kingdom, optional: true

  def self.templates
    @templates ||= YAML.load_file(Rails.root.join('lib', 'game_content',
                                                  'general_templates.yml')).with_indifferent_access
  end
end
