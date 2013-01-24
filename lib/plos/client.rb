require "nokogiri"
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
      result = []
      doc = execute( search_url, { :q => query } )
      if doc && doc.root
        doc.root.children.each do |child|
          next unless child.name == "result"
          child.children.each do |doc|
            result << PLOS::ArticleRef.new(self, doc)
          end
        end
      end
      result
    end

    def search_url
      "/search"
    end

    def execute(url, params={})
      Nokogiri::XML(RestClient.post( "#{self.base_url}#{url}", { :api_key => self.api_key }.merge(params) ) )
    end
  end
end
