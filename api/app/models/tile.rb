# frozen_string_literal: true

class Tile < ApplicationRecord
  belongs_to :map
  has_one :location, dependent: :destroy

  def related_routes
    Route.all.select do |route|
      route.path.any? { |coords| coords == [x_coord, y_coord] }
    end
  end
end
