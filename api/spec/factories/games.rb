# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    association :user
    slot { 0 }
  end
end
