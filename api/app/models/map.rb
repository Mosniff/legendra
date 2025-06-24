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

    map = new(world: world, width: attrs['width'], height: attrs['height'])
    attrs['width'].times do |x|
      attrs['height'].times do |y|
        tile_settings = attrs['tiles']['rows'][x][y]
        tile = map.tiles.build(x_coord: x, y_coord: y, terrain: tile_settings['terrain'])
        next unless tile_settings['location']

        locatable_type = tile_settings['location']['type']
        locatable = locatable_type.classify.constantize.create(name: tile_settings['location']['name'])
        tile.location = Location.create(locatable: locatable)
        locatable.location = tile.location
      end
    end

    map
  end

  def get_tile(x_coord, y_coord)
    tiles.find_by(x_coord: x_coord, y_coord: y_coord)
  end
end
