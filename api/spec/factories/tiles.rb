FactoryBot.define do
  factory :tile do
    x_coord { 1 }
    y_coord { 1 }
    terrain { 'grassland' }
    association :map
  end
end
