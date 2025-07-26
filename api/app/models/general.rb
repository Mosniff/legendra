class General < ApplicationRecord
  belongs_to :world
  belongs_to :kingdom, optional: true
end
