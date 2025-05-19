class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_many :games, dependent: :destroy

  def game_slots
    slots = Array.new(10)
    games.each { |game| slots[game.slot] = game }
    slots
  end
end
