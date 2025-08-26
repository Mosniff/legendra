class AddKingdomToGarrisons < ActiveRecord::Migration[7.1]
  def change
    add_reference :garrisons, :kingdom, foreign_key: true, null: true
  end
end
