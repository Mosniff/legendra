# frozen_string_literal: true

class WorldSerializer
  include JSONAPI::Serializer
  attributes :id

  has_one :map
end
