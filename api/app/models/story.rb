# frozen_string_literal: true

class Story < ApplicationRecord
  belongs_to :world
  delegate :game, to: :world
  belongs_to :scenario
end
