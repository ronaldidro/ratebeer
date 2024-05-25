class Membership < ApplicationRecord
  belongs_to :beerclub
  belongs_to :user
end
