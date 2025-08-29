# frozen_string_literal: true

class CastleSerializer
  include JSONAPI::Serializer

  attributes :id, :name

  attribute :garrisoned_generals do |castle|
    castle.garrison.generals.map do |general|
      GeneralSerializer.new(general).serializable_hash[:data][:attributes]
    end
  end
end
