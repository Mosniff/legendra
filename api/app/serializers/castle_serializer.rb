# frozen_string_literal: true

class CastleSerializer
  include JSONAPI::Serializer

  attributes :id, :name

  has_many :generals do |castle|
    castle.garrison.generals
  end

  attribute :player_controlled, &:player_controlled?
end
