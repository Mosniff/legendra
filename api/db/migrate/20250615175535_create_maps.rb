class CreateMaps < ActiveRecord::Migration[7.1]
  def change
    create_table :maps do |t|
      t.references :world, null: false, foreign_key: true

      t.timestamps
    end
  end
end
