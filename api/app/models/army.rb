# frozen_string_literal: true

class Army < ApplicationRecord
  MAX_GENERALS = 5

  belongs_to :kingdom
  belongs_to :world

  has_many :generals, as: :assignable, after_remove: :destroy_if_empty

  before_update :destroy_if_empty

  def self.create_with_generals(army_attrs, generals)
    army = Army.create!(army_attrs)
    generals.each { |general| general.update!(assignable: army) }
    army.reload
    raise ArgumentError, 'Must have at least 1 general' if army.generals.empty?

    army
  end

  def add_general(general)
    raise ArgumentError, "Army already has #{MAX_GENERALS} generals" if generals.count >= MAX_GENERALS
    raise ArgumentError, 'Cannot add general from a different kingdom' if kingdom && general.kingdom != kingdom

    general.update!(assignable: self)
    save!
  end

  def remove_general(general)
    raise ArgumentError, 'General is not assigned to this army' unless general.assignable == self

    general.update!(assignable: nil)
    save!
  end

  private

  def destroy_if_empty(_general = nil)
    destroy if generals.empty?
  end
end
