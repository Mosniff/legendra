# frozen_string_literal: true

class TileSerializer
  include JSONAPI::Serializer
  attributes :x_coord, :y_coord, :terrain

  attribute :castle do |tile|
    tile.location.locatable if tile.location && tile.location.locatable_type == 'Castle'
  end

  attribute :town do |tile|
    tile.location.locatable if tile.location && tile.location.locatable_type == 'Town'
  end
end
