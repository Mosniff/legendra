# frozen_string_literal: true

class Army < ApplicationRecord
  MAX_GENERALS = 5

  belongs_to :kingdom
  belongs_to :world

  has_many :generals, as: :assignable, after_remove: :destroy_if_empty

  after_update :destroy_if_empty

  def self.spawn_with_generals(army_attrs, generals)
    army = Army.create!(army_attrs)
    generals.each { |general| general.update!(assignable: army) }
    army.reload
    raise ArgumentError, 'Must have at least 1 general' if army.generals.empty?

    army
  end

  def add_generals(generals_to_add)
    unless generals_to_add.is_a?(Enumerable) && generals_to_add.all? { |g| g.is_a?(General) }
      raise ArgumentError, 'generals_to_add must be an collection of General objects'
    end

    if (generals.count + generals_to_add.count) > MAX_GENERALS
      raise ArgumentError,
            "Army already has #{MAX_GENERALS} generals"
    end

    generals_to_add.each do |general|
      raise ArgumentError, 'Cannot add general from a different kingdom' if kingdom && general.kingdom != kingdom

      general.update!(assignable: self)
    end

    save!
  end

  def add_to_garrison(garrison, generals)
    raise ArgumentError, 'Must have at least 1 general' if generals.empty?
    raise ArgumentError, 'All generals must come from this army' unless generals.all? { |g| g.assignable == self }

    unless garrison.x_coord == x_coord && garrison.y_coord == y_coord
      raise ArgumentError,
            'Cannot add to garrison from a different tile'
    end

    garrison.add_generals(generals)
    destroy_if_empty
    garrison
  end

  def remove_general(general)
    raise ArgumentError, 'General is not assigned to this army' unless general.assignable == self

    general.update!(assignable: nil)
    save!
    destroy_if_empty
  end

  def tile
    world.map.tiles.find { |tile| tile.x_coord == x_coord && tile.y_coord == y_coord }
  end

  def player_controlled?
    kingdom&.is_player_kingdom || false
  end

  def destroy_if_empty(_general = nil)
    destroy if generals.empty?
  end
end
