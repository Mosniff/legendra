# frozen_string_literal: true

class Scenario < ApplicationRecord
  has_one :story, dependent: :destroy
end
