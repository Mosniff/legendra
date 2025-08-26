class General < ApplicationRecord
  belongs_to :world
  belongs_to :kingdom, optional: true
  belongs_to :assignable, polymorphic: true, optional: true
end
