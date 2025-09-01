# frozen_string_literal: true

class TownSerializer
  include JSONAPI::Serializer

  attributes :id, :name
end
