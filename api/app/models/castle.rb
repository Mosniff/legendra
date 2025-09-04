class Castle < ApplicationRecord
  has_one :location, as: :locatable, dependent: :destroy
  accepts_nested_attributes_for :location
  validates :location, presence: true

  has_one :garrison, dependent: :destroy
  accepts_nested_attributes_for :garrison
  validates :garrison, presence: true

  after_initialize :ensure_garrison

  def empty?
    garrison.generals.empty?
  end

  def world
    location.tile.map.world
  end

  def player_controlled?
    garrison.kingdom&.is_player_kingdom || false
  end

  def x_coord
    location.tile.x_coord
  end

  def y_coord
    location.tile.y_coord
  end

  private

  def ensure_garrison
    build_garrison unless garrison
  end
end
