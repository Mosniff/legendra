class AddGameStateToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :game_state, :string, default: 'story_choice', null: false
  end
end
