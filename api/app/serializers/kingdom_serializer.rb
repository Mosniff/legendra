# frozen_string_literal: true

class KingdomSerializer
  include JSONAPI::Serializer
  attributes :id, :name
end
