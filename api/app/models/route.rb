# frozen_string_literal: true

class Route < ApplicationRecord
  belongs_to :location_a, class_name: 'Location'
  belongs_to :location_b, class_name: 'Location'

  validates :location_a_id, uniqueness: { scope: :location_b_id }
  validate :locations_are_different

  before_validation :order_location_ids

  def other_end(location)
    location == location_a ? location_b : location_a
  end

  private

  def order_location_ids
    return unless location_a_id && location_b_id && location_a_id > location_b_id

    self.location_a_id, self.location_b_id = location_b_id, location_a_id
  end

  def locations_are_different
    errors.add(:location_b_id, 'must be different') if location_a_id == location_b_id
  end
end
