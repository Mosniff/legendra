class CreateScenarios < ActiveRecord::Migration[7.1]
  def change
    create_table :scenarios do |t|
      t.string :title

      t.timestamps
    end
  end
end
