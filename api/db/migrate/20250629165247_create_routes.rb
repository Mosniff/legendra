class CreateRoutes < ActiveRecord::Migration[7.1]
  def change
    create_table :routes do |t|
      t.references :location_a, null: false, foreign_key: { to_table: :locations }
      t.references :location_b, null: false, foreign_key: { to_table: :locations }
      t.json :path, null: false, default: []
      t.timestamps
    end
    add_index :routes, %i[location_a_id location_b_id], unique: true
  end
end
