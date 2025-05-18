class AddSlotToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :slot, :integer
  end
end
