# frozen_string_literal: true

class Map < ApplicationRecord
  belongs_to :world
  has_many :tiles, dependent: :destroy

  def self.templates
    @templates ||= YAML.load_file(Rails.root.join('lib', 'game_content', 'map_templates.yml')).with_indifferent_access
  end

  def self.build_from_template(template_name, world:)
    attrs = templates[template_name]
    raise ArgumentError, "Unknown map template: #{template_name}" unless attrs

    map = new(world: world)
    rows = attrs['tiles']['rows'] || []

    rows.each_with_index do |row, y|
      row.each_with_index do |terrain, x|
        map.tiles.build(x_coord: x, y_coord: y, terrain: terrain)
      end
    end

    map
  end

  def get_tile(x, y)
    tiles.find_by(x_coord: x, y_coord: y)
  end
end
