class Tile < ApplicationRecord
  belongs_to :map
  has_one :location
end
