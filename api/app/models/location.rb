class Location < ApplicationRecord
  belongs_to :tile
  belongs_to :locatable, polymorphic: true
  validates :locatable, presence: true

  has_many :routes_as_a, class_name: 'Route', foreign_key: :location_a_id, dependent: :destroy
  has_many :routes_as_b, class_name: 'Route', foreign_key: :location_b_id, dependent: :destroy

  def routes
    Route.where('location_a_id = ? OR location_b_id = ?', id, id)
  end

  def self.get_location_at(x_coord, y_coord)
    Tile.get_tile(x_coord, y_coord).location
  end

  def connected_locations
    routes.map { |route| route.other_end(self) }
  end

  def get_journey_to(location)
    route = routes.find { |route| route.other_end(self) == location }
    direction = route.location_a == self ? 'forwards' : 'backwards'
    { route: route, direction: direction }
  end
end
