class CreateKingdoms < ActiveRecord::Migration[7.1]
  def change
    create_table :kingdoms do |t|
      t.references :world, null: false, foreign_key: true
      t.string :name
      t.boolean :is_player_kingdom, default: false

      t.timestamps
    end
  end
end
