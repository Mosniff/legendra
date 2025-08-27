class Kingdom < ApplicationRecord
  belongs_to :world
  has_many :generals, dependent: :destroy
  has_many :garrison, dependent: :destroy

  validate :only_one_player_kingdom_per_world

  private

  def only_one_player_kingdom_per_world
    return unless is_player_kingdom

    existing = world.kingdoms.where(is_player_kingdom: true)
    # Exclude self in case of update
    existing = existing.where.not(id: id) if persisted?
    return unless existing.exists?

    errors.add(:is_player_kingdom, 'player kingdom already exists for this world')
  end
end
