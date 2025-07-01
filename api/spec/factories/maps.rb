FactoryBot.define do
  factory :map do
    height { 5 }
    width { 5 }
    association :world
  end
end
