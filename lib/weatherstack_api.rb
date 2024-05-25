class WeatherstackApi
  def self.current_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{ERB::Util.url_encode(city)}"

    response = HTTParty.get url
    weather = response.parsed_response["current"]

    return nil if weather.is_a?(Hash) && weather['temperature'].nil?

    Weather.new(weather)
  end

  def self.key
    # WEATHERSTACK_APIKEY="6035c4eab3efccaeeb32158f903408f2" rails s
    return nil if Rails.env.test? # while testing api is not needed, return nil
    raise 'WEATHERSTACK_APIKEY env variable not defined' if ENV['WEATHERSTACK_APIKEY'].nil?

    ENV.fetch('WEATHERSTACK_APIKEY')
  end
end
