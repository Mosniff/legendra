class Location < ApplicationRecord
  belongs_to :tile
  belongs_to :locatable, polymorphic: true
  validates :locatable, presence: true
end
