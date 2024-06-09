module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    # this generates SQL
    # ratings.average(:score).to_f

    # Count and save based on the fetched ratings objects (associated to a beer)
    rating_count = ratings.size

    return 0 if rating_count == 0

    ratings.map(&:score).sum / rating_count
  end
end
