class AddActiveToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :active, :boolean, default: false, null: false
  end
end
