# frozen_string_literal: true

class MapSerializer
  include JSONAPI::Serializer

  attributes :id, :height, :width
  has_many :tiles

  attribute :castles do |map|
    map.castles.map do |castle|
      CastleSerializer.new(castle).serializable_hash[:data][:attributes]
    end
  end
end
