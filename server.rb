require 'sinatra'
require 'random_restaurant_selector'


post '/' do
  puts params
  request_hash = { location: ENV['MY_LOCATION'], term: 'food', radius: 900, open_now: false, price: '1,2', limit: 50 }
  search = RandomRestaurantSelector::Search.new(request_hash)
  restaurant = search.gimme_a_restaurant(search.get_businesses)
  restaurant.send_to_slack
  puts params
end