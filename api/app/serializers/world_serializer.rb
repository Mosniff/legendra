# frozen_string_literal: true

class WorldSerializer
  include JSONAPI::Serializer

  attributes :id

  has_one :map
  has_many :kingdoms
  has_many :generals
  has_many :armies

  has_many :castles do |world|
    world.castles
  end

  has_many :towns do |world|
    world.towns
  end
end
