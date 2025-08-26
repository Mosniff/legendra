class Garrison < ApplicationRecord
  MAX_GENERALS = 8

  belongs_to :castle
  belongs_to :kingdom, optional: true
  has_many :generals, as: :assignable

  before_save :determine_kingdom

  def add_general(general)
    raise ArgumentError, "Garrison already has #{MAX_GENERALS} generals" if generals.count >= MAX_GENERALS
    raise ArgumentError, 'Cannot add general from a different kingdom' if kingdom && general.kingdom != kingdom

    general.update!(assignable: self)
    save!
  end

  def remove_general(general)
    raise ArgumentError, 'General is not assigned to this garrison' unless general.assignable == self

    general.update!(assignable: nil)
    save!
  end

  private

  def determine_kingdom
    first_general = generals.first
    self.kingdom_id = first_general&.kingdom_id
  end
end
