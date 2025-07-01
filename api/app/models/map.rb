# frozen_string_literal: true

class Map < ApplicationRecord
  belongs_to :world
  has_many :tiles, dependent: :destroy
  has_many :locations, through: :tiles

  def self.templates
    @templates ||= YAML.load_file(Rails.root.join('lib', 'game_content', 'map_templates.yml')).with_indifferent_access
  end

  def self.build_from_template(template_name, world:)
    attrs = templates[template_name]
    raise ArgumentError, "Unknown map template: #{template_name}" unless attrs

    map = new(world: world, width: attrs['width'], height: attrs['height'])
    location_lookup = {}

    attrs['width'].times do |x|
      attrs['height'].times do |y|
        tile_settings = attrs['tiles']['rows'][x][y]
        tile = map.tiles.build(x_coord: x, y_coord: y, terrain: tile_settings['terrain'])
        next unless tile_settings['location']

        locatable_type = tile_settings['location']['type']
        locatable = locatable_type.classify.constantize.create(name: tile_settings['location']['name'])
        location = Location.create(locatable: locatable)
        tile.location = location
        locatable.location = location

        location_lookup[locatable.name] = location
      end
    end

    # Save map and all nested tiles/locations before creating routes
    map.save!

    attrs['routes']&.each do |route_attrs|
      from_location = location_lookup[route_attrs['from']]
      to_location = location_lookup[route_attrs['to']]
      path = route_attrs['path']

      next unless from_location && to_location

      Route.create!(
        location_a_id: from_location.id,
        location_b_id: to_location.id,
        path: path
      )
    end

    map
  end

  def get_tile(x_coord, y_coord)
    tiles.find_by(x_coord: x_coord, y_coord: y_coord)
  end

  def self.check_distance(a_coords, b_coords)
    (a_x, a_y) = a_coords
    (b_x, b_y) = b_coords
    [(a_x - b_x).abs, (a_y - b_y).abs].max
  end

  def routes
    # Collect all routes from all locations, flatten, and remove duplicates
    locations.includes(:routes_as_a, :routes_as_b).flat_map do |location|
      location.routes
    end.uniq
  end
end
