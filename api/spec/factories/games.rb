# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    association :user
    slot { 0 }

    trait :with_story do
      transient do
        story { 'test_story' }
      end

      after(:create) do |game, evaluator|
        game.world.select_story(evaluator.story)
      end
    end
  end
end
