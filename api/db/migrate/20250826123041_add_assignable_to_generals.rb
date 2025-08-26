class AddAssignableToGenerals < ActiveRecord::Migration[7.1]
  def change
    add_reference :generals, :assignable, polymorphic: true
  end
end
