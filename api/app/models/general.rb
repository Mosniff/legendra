class General < ApplicationRecord
  belongs_to :world
  belongs_to :kingdom, optional: true
  belongs_to :assignable, polymorphic: true, optional: true

  after_update :cleanup_army_if_leaving, if: :left_army?

  private

  def left_army?
    (saved_change_to_assignable_type? || saved_change_to_assignable_id?) &&
      assignable_type_before_last_save == 'Army' &&
      assignable_id_before_last_save.present?
  end

  def cleanup_army_if_leaving
    army = Army.find_by(id: assignable_id_before_last_save)
    army&.destroy_if_empty
  end
end
