# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    association :user
    slot { 1 }
  end
end
