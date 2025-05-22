class CreateStories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.references :world, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
