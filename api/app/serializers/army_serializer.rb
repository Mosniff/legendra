# frozen_string_literal: true

class ArmySerializer
  include JSONAPI::Serializer

  belongs_to :kingdom
  attributes :id, :x_coord, :y_coord
  has_many :generals

  attribute :player_controlled, &:player_controlled?
end
