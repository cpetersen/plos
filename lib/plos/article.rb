module PLOS
  class Article
    include XmlHelpers

    attr_accessor :node
    attr_accessor :id
    attr_accessor :article_title
    attr_accessor :article_ids
    attr_accessor :journal_title
    attr_accessor :journal_ids
    attr_accessor :issns
    attr_writer :affiliations
    attr_writer :contributors
    attr_writer :figures
    attr_writer :references
    attr_writer :sections
    attr_writer :named_content

    def initialize(id, node)
      self.id = id
      self.node = node

      self.article_title = tag_value(node.search("title-group"), "article-title")
      self.journal_title = tag_value(node.search("journal-title-group"), "journal-title")

      self.issns = nodes_to_hash(node.search("journal-meta/issn"), "pub-type")
      self.journal_ids = nodes_to_hash(node.search("journal-meta/journal-id"), "journal-id-type")
      self.article_ids = nodes_to_hash(node.search("article-meta/article-id"), "pub-id-type")

      node.search("aff").each do |aff_node|
        self.affiliations << PLOS::Affiliation.new(aff_node)
      end

      node.search("contrib").each do |contrib_node|
        self.contributors << PLOS::Contributor.new(contrib_node)
      end

      node.search("fig").each do |fig_node|
        self.figures << PLOS::Figure.new(fig_node)
      end

      node.search("sec").each do |section_node|
        self.sections << PLOS::Section.new(section_node)
      end

      node.search("ref").each do |ref_node|
        self.references << PLOS::Reference.new(ref_node)
      end

      node.search("named-content").each do |content_node|
        type = content_node.attr("content-type")
        value = content_node.text
        named_content << {:type => type, :value => value}
      end
    end

    def self.base_url
      "http://www.plosone.org"
    end

    def self.get(id)
      PLOS::Article.new(id, self.xml(id))
    end

    def self.xml(id)
      Nokogiri::XML(self.content(id))
    end

    def self.content(id)
      RestClient.get(self.url(id))
    end

    def self.url(id, format="XML")
      # format = "XML|PDF"
      "#{base_url}/article/fetchObjectAttachment.action?uri=info:doi/#{id}&representation=#{format}"
    end
    
    def self.ris_citation_url(id)
      "#{base_url}/article/getRisCitation.action?articleURI=info:doi/#{id}"
    end

    def self.bib_tex_citation_url(id)
      "#{base_url}/article/getBibTexCitation.action?articleURI=info:doi/#{id}"
    end

    def self.citation(id, format="RIS")
      url = (format == "RIS" ? PLOS::Article.ris_citation_url(id) : PLOS::Article.bib_tex_citation_url(id))
      RestClient.get(url)
    end

    def authors
      contributors.collect { |contrib| contrib.name if contrib.type == "author" }.compact
    end

    def editors
      contributors.collect { |contrib| contrib.name if contrib.type == "editor" }.compact
    end

    def affiliations
      @affiliations ||= []
    end

    def contributors
      @contributors ||= []
    end

    def figures
      @figures ||= []
    end

    def references
      @references ||= []
    end

    def sections
      @sections ||= []
    end

    def named_content
      @named_content ||= []
    end

    def citation(format="RIS")
      PLOS::Article.citation(id, format)
    end
  end
end
