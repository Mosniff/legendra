# frozen_string_literal: true

class GameSerializer
  include JSONAPI::Serializer
  attributes :id, :slot, :user_id, :created_at, :updated_at, :active
end
