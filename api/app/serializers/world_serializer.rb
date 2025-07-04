# frozen_string_literal: true

class WorldSerializer
  include JSONAPI::Serializer
  attributes :id

  has_one :map
  has_many :kingdoms
  has_many :generals
end
