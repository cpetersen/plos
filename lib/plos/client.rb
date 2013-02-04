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

    def all(start=0, rows=50)
      search("*:*", rows, start)
    end

    def search(query, start=0, rows=50)
      result = PLOS::ArticleSet.new
      doc = execute( search_url, { :q => query, :rows => rows, :start => start } )
      if doc && doc.root
        doc.root.children.each do |child|
          if child.name == "lst"
            child.children.each do |int|
              case int.attr("name")
              when "status"
                result.status = int.text
              when "QTime"
                result.time = int.text.to_i
              end
            end
          elsif child.name == "result"
            result.num_found = child.attr("numFound").to_i if child.attr("numFound")
            result.start = child.attr("start").to_i if child.attr("start")
            result.max_score = child.attr("maxScore").to_f if child.attr("maxScore")
            child.children.each do |doc|
              result << PLOS::ArticleRef.new(self, doc)
            end
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
