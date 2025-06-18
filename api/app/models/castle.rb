class Castle < ApplicationRecord
  has_one :location, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for :location
  validates :location, presence: true
end
