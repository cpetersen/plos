module PLOS
  class Article
    include XmlHelpers

    attr_accessor :article_title
    attr_accessor :article_ids
    attr_accessor :journal_title
    attr_accessor :journal_ids
    attr_accessor :issns
    attr_writer :references
    attr_writer :sections

    def initialize(node)
      self.article_title = tag_value(node.search("title-group"), "article-title")
      self.journal_title = tag_value(node.search("journal-title-group"), "journal-title")

      self.issns = nodes_to_hash(node.search("journal-meta/issn"), "pub-type")
      self.journal_ids = nodes_to_hash(node.search("journal-meta/journal-id"), "journal-id-type")
      self.article_ids = nodes_to_hash(node.search("article-meta/article-id"), "pub-id-type")

      node.search("sec").each do |section_node|
        sections << PLOS::Section.new(section_node)
      end

      node.search("ref").each do |ref_node|
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
