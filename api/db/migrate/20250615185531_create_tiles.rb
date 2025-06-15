class CreateTiles < ActiveRecord::Migration[7.1]
  def change
    create_table :tiles do |t|
      t.references :map, null: false, foreign_key: true
      t.integer :x_coord
      t.integer :y_coord
      t.string :terrain

      t.timestamps
    end
  end
end
