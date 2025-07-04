class CreateGenerals < ActiveRecord::Migration[7.1]
  def change
    create_table :generals do |t|
      t.string :name
      t.references :world, null: false, foreign_key: true
      t.references :kingdom, null: true, foreign_key: true

      t.timestamps
    end
  end
end
