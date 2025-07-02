class Location < ApplicationRecord
  belongs_to :tile
  belongs_to :locatable, polymorphic: true
  validates :locatable, presence: true

  has_many :routes_as_a, class_name: 'Route', foreign_key: :location_a_id, dependent: :destroy
  has_many :routes_as_b, class_name: 'Route', foreign_key: :location_b_id, dependent: :destroy

  def routes
    Route.where('location_a_id = ? OR location_b_id = ?', id, id)
  end

  def connected_locations
    routes.map { |route| route.other_end(self) }
  end

  def get_route_to(location)
    routes.find { |route| route.other_end(self) == location }
  end
end
