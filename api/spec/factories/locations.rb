FactoryBot.define do
  factory :location do
    association :tile

    trait :with_castle do
      association :locatable, factory: :castle
    end

    trait :with_town do
      association :locatable, factory: :town
    end
  end
end
