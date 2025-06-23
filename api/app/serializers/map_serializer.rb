# frozen_string_literal: true

class MapSerializer
  include JSONAPI::Serializer
  attributes :id
  has_many :tiles
end
