# frozen_string_literal: true

class TownSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :x_coord, :y_coord
end
