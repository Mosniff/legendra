class CreateClashes < ActiveRecord::Migration[7.1]
  def change
    create_table :clashes do |t|
      t.references :world, null: false, foreign_key: true
      t.references :tile, null: false, foreign_key: true
      t.references :game, foreign_key: true
      t.references :side_a_army, foreign_key: { to_table: :armies }
      t.references :side_b_army, foreign_key: { to_table: :armies }
      t.references :forced_winner, foreign_key: { to_table: :kingdoms }, null: true

      t.timestamps
    end
  end
end
