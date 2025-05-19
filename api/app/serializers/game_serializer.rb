# frozen_string_literal: true

class GameSerializer
  include JSONAPI::Serializer
  attributes :id, :slot, :user_id, :created_at, :updated_at
  # Add other Game attributes here as needed
end
