require "rest_client"

module PLOS
  class Client
    attr_accessor :api_key
    attr_accessor :base_url

    def initialize(api_key, base_url="http://api.plos.org")
      self.api_key = api_key
      self.base_url = base_url
    end

    def search(query)
      execute( search_url, { :q => query } )
    end

    def search_url
      "/search"
    end

    def execute(url, params={})
      RestClient.post( "#{self.base_url}#{url}", { :api_key => self.api_key }.merge(params) )
    end
  end
end