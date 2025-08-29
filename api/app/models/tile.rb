# frozen_string_literal: true

class Tile < ApplicationRecord
  belongs_to :map
  has_one :location, dependent: :destroy

  def related_routes
    Route.all.select do |route|
      route.path.any? { |coords| coords == [x_coord, y_coord] }
    end
  end

  def castle
    raise ArgumentError, 'Tile does not have a Castle' unless location&.locatable_type == 'Castle'

    location.locatable
  end

  def town
    raise ArgumentError, 'Tile does not have a Town' unless location&.locatable_type == 'Town'

    location.locatable
  end
end
