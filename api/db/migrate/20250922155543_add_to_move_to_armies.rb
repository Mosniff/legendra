class AddToMoveToArmies < ActiveRecord::Migration[7.1]
  def change
    add_column :armies, :to_move, :boolean, null: true, default: false
  end
end
