class Brewery < ApplicationRecord
  include RatingAverage
  extend TopRated

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }
  validate :year_not_greater_than_this_year

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_not_greater_than_this_year
    errors.add(:year, "can't be greater than current year") if year.present? && year > Date.today.year
  end
end
