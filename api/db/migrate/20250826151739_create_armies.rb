class CreateArmies < ActiveRecord::Migration[7.1]
  def change
    create_table :armies do |t|
      t.references :kingdom, null: false, foreign_key: true
      t.references :world, null: false, foreign_key: true
      t.integer :x_coord
      t.integer :y_coord

      t.timestamps
    end
  end
end
