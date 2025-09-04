# frozen_string_literal: true

class Route < ApplicationRecord
  belongs_to :location_a, class_name: 'Location'
  belongs_to :location_b, class_name: 'Location'

  has_many :currently_traveling_armies, class_name: 'Army', foreign_key: 'route_id'

  validates :location_a_id, uniqueness: { scope: :location_b_id }
  validate :locations_are_different
  validate :path_is_sequential_and_adjacent

  before_validation :order_location_ids

  def other_end(location)
    location == location_a ? location_b : location_a
  end

  def find_path_index_from_coords(x_coord, y_coord)
    path.index { |coords| coords == [x_coord, y_coord] }
  end

  private

  def order_location_ids
    return unless location_a_id && location_b_id && location_a_id > location_b_id

    self.location_a_id, self.location_b_id = location_b_id, location_a_id
  end

  def locations_are_different
    errors.add(:location_b_id, 'must be different') if location_a_id == location_b_id
  end

  def path_is_sequential_and_adjacent
    return if path.blank? || path.size < 2

    path.each_cons(2) do |a, b|
      if Map.check_distance(a, b) != 1
        errors.add(:path, 'must be sequential and adjacent (distance 1 between each step)')
        break
      end
    end

    # Check first tile is adjacent to location_a
    if location_a && path.first
      a_coords = [location_a.tile.x_coord, location_a.tile.y_coord]
      unless Map.check_distance(a_coords, path.first) == 1
        errors.add(:path, 'must link two locations (path must contain adjacent tiles to A and B)')
      end
    end

    # Check last tile is adjacent to location_b
    return unless location_b && path.last

    b_coords = [location_b.tile.x_coord, location_b.tile.y_coord]
    return if Map.check_distance(b_coords, path.last) == 1

    errors.add(:path, 'must link two locations (path must contain adjacent tiles to A and B)')
  end
end
