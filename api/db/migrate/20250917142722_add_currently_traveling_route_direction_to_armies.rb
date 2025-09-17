class AddCurrentlyTravelingRouteDirectionToArmies < ActiveRecord::Migration[7.1]
  def change
    add_column :armies, :currently_traveling_route_direction, :string, null: true
  end
end
