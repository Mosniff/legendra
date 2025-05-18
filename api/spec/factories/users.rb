# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test-user-1@test.com' }
    password { 'password123' }
  end
end
