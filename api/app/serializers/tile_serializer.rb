# frozen_string_literal: true

class TileSerializer
  include JSONAPI::Serializer
  attributes :x_coord, :y_coord, :terrain
end
