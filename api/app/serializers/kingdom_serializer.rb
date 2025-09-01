# frozen_string_literal: true

class KingdomSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :is_player_kingdom
end
