class CreateWorlds < ActiveRecord::Migration[7.1]
  def change
    create_table :worlds do |t|
      t.references :game, null: false, foreign_key: true, index: false

      t.timestamps
    end
    add_index :worlds, :game_id, unique: true
  end
end
