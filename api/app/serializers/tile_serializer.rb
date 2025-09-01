# frozen_string_literal: true

class TileSerializer
  include JSONAPI::Serializer

  attributes :x_coord, :y_coord, :terrain

  has_one :castle do |tile|
    tile.location.locatable if tile.location && tile.location.locatable_type == 'Castle'
  end

  has_one :town do |tile|
    tile.location.locatable if tile.location && tile.location.locatable_type == 'Town'
  end

  # attribute :castle_id do |tile|
  #   tile.location.locatable.id if tile.location && tile.location.locatable_type == 'Castle'
  # end

  # attribute :town_id do |tile|
  #   tile.location.locatable.id if tile.location && tile.location.locatable_type == 'Town'
  # end

  attribute :is_route_tile do |tile|
    tile.related_routes.length.positive?
  end
end
