require 'httparty'

module RandomRestaurantSelector
  class Business
    attr_accessor :name, :display_phone, :distance, :price, :image_url, :url, :is_closed, :coordinates, :id, :phone,
                  :review_count, :categories, :location, :rating

    def initialize(biz_attr)
      @name = biz_attr['name']
      @display_phone = biz_attr['display_phone']
      @distance = biz_attr['distance']
      @price = biz_attr['price']
      @image_url = biz_attr['image_url']
      @url = biz_attr['url']
      @is_closed = biz_attr['is_closed']
      @coordinates = biz_attr['coordinates']
      @id = biz_attr['id']
      @phone = biz_attr['phone']
      @review_count = biz_attr['review_count']
      @categories = biz_attr['categories']
      @location = biz_attr['location']
      @rating = biz_attr['rating']
    end

    def distance
      sprintf('%.2f', (@distance / 1609.344)) unless @distance.nil?
    end

    def categories
      arr = @categories.map { |c| c['title'] }
      arr.join(", ")
    end

    def print_to_console
      puts "We will be eating at #{name} today!"
      puts "#{name} is #{distance} miles away."
      puts "#{name} has a Yelp rating of #{rating}"
      puts categories.to_s
    end

    def send_to_slack
      slack_message_hash = {
        username: 'random_restaurant_selector',
        attachments: slack_attachment
      }.to_json

      HTTParty.post(ENV['SLACK_WEBHOOK_URL'], body: slack_message_hash)
    end

    private

    def slack_attachment
      [
        fallback: "Yelp Restaurant Chooser: selection for today: #{name}",
        color: '#36a64f',
        pretext: "We will be eating at #{name} today!",
        author_name: 'Random Restaurant Selector',
        author_link: 'http://www.christiansamuel.net/',
        author_icon: 'https://s3-media3.fl.yelpcdn.com/assets/srv0/styleguide/b62d62e8722a/assets/img/brand_guidelines/yelp_fullcolor_outline@2x.png',
        title: name.to_s,
        title_link: url.to_s,
        text: "Category: #{categories} \nRating: #{rating} out of 5 stars \nPrice Range: #{price}\nDistance: #{distance} miles away",
        image_url: image_url.to_s,
        footer: 'Created by: Christian Samuel',
        footer_icon: ENV['SLACK_AVATAR']
      ]
    end
  end
end
