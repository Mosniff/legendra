class AddTurnToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :turn, :integer
  end
end
