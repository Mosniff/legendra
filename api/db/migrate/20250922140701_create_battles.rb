class CreateBattles < ActiveRecord::Migration[7.1]
  def change
    create_table :battles do |t|
      t.references :side_a, null: false, foreign_key: { to_table: :kingdoms }
      t.references :side_b, null: false, foreign_key: { to_table: :kingdoms }
      t.references :tile, null: false, foreign_key: true
      t.references :world, null: false, foreign_key: true
      t.integer :turn, null: false
      t.string :state, null: false, default: 'awaiting resolution'
      t.boolean :is_draw, null: false, default: false
      t.references :winner, foreign_key: { to_table: :kingdoms }

      t.timestamps
    end
  end
end
