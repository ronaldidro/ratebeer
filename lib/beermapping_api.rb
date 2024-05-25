class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { get_places_in(city) }
    # places = Rails.cache.read(city)
    # return places if places

    # places = get_places_in(city)
    # Rails.cache.write(city, places)
    # places
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.get_place(piece)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{piece}"

    response = HTTParty.get url
    place = response.parsed_response["bmp_locations"]["location"]

    return nil if place.is_a?(Hash) && place['id'].nil?

    Place.new(place)
  end

  def self.key
    # BEERMAPPING_APIKEY="731955affc547174161dbd6f97b46538" rails s
    return nil if Rails.env.test? # while testing api is not needed, return nil
    raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?

    ENV.fetch('BEERMAPPING_APIKEY')
  end
end
