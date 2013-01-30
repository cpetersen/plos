module PLOS
  class Reference
    include PLOS::XmlHelpers

    attr_accessor :id
    attr_accessor :label
    attr_accessor :year
    attr_accessor :type
    attr_accessor :title
    attr_accessor :source
    attr_accessor :volume
    attr_accessor :first_page
    attr_accessor :last_page
    attr_writer :authors

    def initialize(node)
      self.id = node.attr("id") if node.attr("id")
      self.label = tag_value(node, "label")
      citation_node = node.search("//element-citation")
      self.type = citation_node.attr("publication-type").value if citation_node.attr("publication-type")
      self.year = tag_value(citation_node, "year")
      self.title = tag_value(citation_node, "article-title")
      self.source = tag_value(citation_node, "source")
      self.volume = tag_value(citation_node, "volume")
      self.first_page = tag_value(citation_node, "fpage")
      self.last_page = tag_value(citation_node, "lpage")
    end

    def authors
      @authors ||= []
    end
  end
end
