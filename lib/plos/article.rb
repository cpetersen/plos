require "rest_client"

module PLOS
  class Article
    attr_writer :sections

    def initialize(node)
      node.search("//sec").each do |section_node|
        sections << PLOS::Section.new(section_node)
      end
    end

    def sections
      @sections ||= []
    end
  end
end
