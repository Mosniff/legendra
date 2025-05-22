# frozen_string_literal: true

class World < ApplicationRecord
  belongs_to :game
  has_one :story, dependent: :destroy
end
