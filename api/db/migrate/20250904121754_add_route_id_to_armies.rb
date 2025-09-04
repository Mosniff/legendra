class AddRouteIdToArmies < ActiveRecord::Migration[7.1]
  def change
    add_reference :armies, :route, foreign_key: true, null: true
  end
end
