# frozen_string_literal: true

class Map < ApplicationRecord
  belongs_to :world
  has_many :tiles, dependent: :destroy
  has_many :locations, through: :tiles

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

  def castles
    Castle.joins(location: :tile).where(tiles: { map_id: id })
  end

  def towns
    Town.joins(location: :tile).where(tiles: { map_id: id })
  end
end
