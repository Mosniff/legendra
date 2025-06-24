# frozen_string_literal: true

class Tile < ApplicationRecord
  belongs_to :map
  has_one :location, dependent: :destroy
end
