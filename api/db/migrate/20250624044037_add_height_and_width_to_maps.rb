class AddHeightAndWidthToMaps < ActiveRecord::Migration[7.1]
  def change
    add_column :maps, :height, :integer
    add_column :maps, :width, :integer
  end
end
