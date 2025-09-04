class Town < ApplicationRecord
  has_one :location, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for :location
  validates :location, presence: true

  def x_coord
    location.tile.x_coord
  end

  def y_coord
    location.tile.y_coord
  end
end
