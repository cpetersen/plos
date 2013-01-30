module PLOS
  class Article
    attr_writer :references
    attr_writer :sections

    def initialize(node)
      node.search("//sec").each do |section_node|
        sections << PLOS::Section.new(section_node)
      end

      node.search("//ref").each do |ref_node|
        references << PLOS::Reference.new(ref_node)
      end
    end

    def references
      @references ||= []
    end

    def sections
      @sections ||= []
    end
  end
end
