FactoryBot.define do
  factory :tile do
    map { nil }
    x_coord { 1 }
    y_coord { 1 }
    terrain { "MyString" }
  end
end
