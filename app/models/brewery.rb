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

  after_create_commit do
    status = active? ? "active" : "retired"
    count = active? ? self.class.active.count : self.class.retired.count

    broadcast_append_to "breweries_index", partial: "breweries/brewery_row", target: "#{status}_brewery_rows"
    broadcast_replace_to "breweries_index", partial: "breweries/brewery_count", target: "#{status}_brewery_count", locals: { status:, count: }
  end

  after_destroy_commit do
    status = active? ? "active" : "retired"
    count = active? ? self.class.active.count : self.class.retired.count

    broadcast_remove_to "breweries_index", target: self
    broadcast_replace_to "breweries_index", partial: "breweries/brewery_count", target: "#{status}_brewery_count", locals: { status:, count: }
  end
end
