json.extract! brewery, :id, :name, :year, :active
json.beers do
  json.size brewery.beers.size
end
