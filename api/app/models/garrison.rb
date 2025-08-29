class Garrison < ApplicationRecord
  MAX_GENERALS = 8

  belongs_to :castle
  belongs_to :kingdom, optional: true
  has_many :generals, as: :assignable

  before_save :determine_kingdom

  def add_generals(generals_to_add)
    unless generals_to_add.is_a?(Enumerable) && generals_to_add.all? { |g| g.is_a?(General) }
      raise ArgumentError, 'generals_to_add must be an collection of General objects'
    end

    if (generals.count + generals_to_add.count) > MAX_GENERALS
      raise ArgumentError,
            "Garrison already has #{MAX_GENERALS} generals"
    end

    generals_to_add.each do |general|
      raise ArgumentError, 'Cannot add general from a different kingdom' if kingdom && general.kingdom != kingdom

      general.update!(assignable: self)
    end

    save!
  end

  def remove_general(general)
    raise ArgumentError, 'General is not assigned to this garrison' unless general.assignable == self

    general.update!(assignable: nil)
    save!
  end

  def create_army(generals)
    raise ArgumentError, 'Must have at least 1 general' if generals.empty?

    army = Army.create!(world: castle.world, kingdom: kingdom, x_coord: x_coord, y_coord: y_coord)
    army.add_generals(generals)
    army
  end

  def add_to_army(army, generals)
    raise ArgumentError, 'Must have at least 1 general' if generals.empty?
    raise ArgumentError, 'All generals must come from this garrison' unless generals.all? { |g| g.assignable == self }

    unless army.x_coord == x_coord && army.y_coord == y_coord
      raise ArgumentError,
            'Cannot add to army from a different tile'
    end

    army.add_generals(generals)
    army
  end

  def x_coord
    castle.location.tile.x_coord
  end

  def y_coord
    castle.location.tile.y_coord
  end

  private

  def determine_kingdom
    first_general = generals.first
    self.kingdom_id = first_general&.kingdom_id
  end
end
