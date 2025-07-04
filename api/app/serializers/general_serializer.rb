# frozen_string_literal: true

class GeneralSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :kingdom_id
end
