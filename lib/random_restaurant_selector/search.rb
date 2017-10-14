require 'httparty'

module RandomRestaurantSelector
  class Search
    attr_accessor :term, :location, :latitude, :longitude, :radius, :categories, :locale, :limit,
                  :offset, :sort_by, :price, :open_now, :open_at, :attributes

    def initialize(req_attr)
      req_attr = SEARCH_DEFAULTS.merge(req_attr)
      @term = req_attr[:term]
      @location = req_attr[:location]
      @latitude = req_attr[:latitude]
      @longitude = req_attr[:longitude]
      @radius = req_attr[:radius]
      @categories = req_attr[:categories]
      @locale = req_attr[:locale]
      @limit = req_attr[:limit]
      @offset = req_attr[:offset]
      @sort_by = req_attr[:sort_by]
      @price = req_attr[:price]
      @open_now = req_attr[:open_now]
      @open_at = req_attr[:open_at]
      @attributes = req_attr[:attributes]
      @request = build_request(req_attr)
    end

    def get_businesses
      businesses_arr = HTTParty.get(@request, headers: {'Authorization' => "Bearer #{ENV['YELP_ACCESS_TOKEN']}"}).parsed_response['businesses']
      business_objects = []
      businesses_arr.each do |business|
        business_objects << Business.new(business)
      end
      business_objects
    end

    def gimme_a_restaurant(biz_objects)
      biz_objects.sample
    end

    private
    def build_request(req_attr)
      'https://api.yelp.com/v3/businesses/search?' + append_search_parameters(req_attr)
    end

    def append_search_parameters(params)
      string = ''
      params.each do |key, value|
        string += key.to_s + '=' + "#{value}" + '&' unless value.nil?
      end
      string = string.gsub(' ', '+')
      string[-1] = ''
      string
    end
  end
end
