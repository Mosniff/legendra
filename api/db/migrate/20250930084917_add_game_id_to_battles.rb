class AddGameIdToBattles < ActiveRecord::Migration[7.1]
  def change
    add_reference :battles, :game, foreign_key: true, null: true
  end
end
