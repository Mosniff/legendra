class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.references :tile, null: false, foreign_key: true
      t.references :locatable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
