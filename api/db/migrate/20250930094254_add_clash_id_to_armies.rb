class AddClashIdToArmies < ActiveRecord::Migration[7.1]
  def change
    add_reference :armies, :clash, foreign_key: true, null: true
  end
end
