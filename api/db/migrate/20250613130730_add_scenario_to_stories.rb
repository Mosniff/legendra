class AddScenarioToStories < ActiveRecord::Migration[7.1]
  def change
    add_reference :stories, :scenario, null: false, foreign_key: true
  end
end
