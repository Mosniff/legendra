class AddGameStateToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :game_state, :string, default: 'world_gen', null: false
  end
end
