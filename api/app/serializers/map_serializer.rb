# frozen_string_literal: true

class MapSerializer
  include JSONAPI::Serializer
  attributes :id, :height, :width
  has_many :tiles
end
