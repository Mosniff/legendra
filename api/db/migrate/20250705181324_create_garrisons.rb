class CreateGarrisons < ActiveRecord::Migration[7.1]
  def change
    create_table :garrisons do |t|
      t.references :castle, null: false, foreign_key: true
      t.references :kingdom, null: false, foreign_key: true

      t.timestamps
    end
  end
end
